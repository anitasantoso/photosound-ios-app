//
//  ViewController.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 8/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "ViewController.h"
#import "SCUI.h"
#import "InstagramNetworkService.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ViewController

- (IBAction)loginButtonPressed:(id)sender {
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:^(NSError *error) {
                                   
                               }];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }];
}
- (IBAction)recordButtonPressed:(id)sender {
    
    if(self.player.playing) {
        [self.player stop];
    }
    
    NSString *buttonTitle;
    NSError *error;
    if(!self.recorder.recording) {
        buttonTitle = @"Stop";

        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        [self.recorder record];
    } else {
        buttonTitle = @"Record";
        
        [self.recorder stop];
        [[AVAudioSession sharedInstance] setActive:NO error:&error];
    }
    [self.recordButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)playButtonPressed:(id)sender {
    if(!self.recorder.recording) {
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.recorder.url error:nil];
        [self.player setDelegate:self];
        [self.player play];
    }
}

- (IBAction)instagramLoginButtonPressed:(id)sender {
    [[InstagramNetworkService sharedInstance]authenticate];
}

- (IBAction)uploadButtonPressed:(id)sender {
    NSURL *trackURL = [NSURL
                       fileURLWithPath:[
                                        [NSBundle mainBundle]pathForResource:@"example" ofType:@"mp3"]];
    
    SCShareViewController *shareViewController;
    SCSharingViewControllerCompletionHandler handler;
    
    handler = ^(NSDictionary *trackInfo, NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Uploaded track: %@", trackInfo);
        }
    };
    shareViewController = [SCShareViewController
                           shareViewControllerWithFileURL:trackURL
                           completionHandler:handler];
    [shareViewController setTitle:@"Funny sounds"];
    [shareViewController setPrivate:YES];
    [self presentViewController:shareViewController animated:YES completion:nil];
}

- (IBAction)takePhotoButtonPressed:(id)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
//    
//    [stopButton setEnabled:NO];
//    [playButton setEnabled:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
