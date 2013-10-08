//
//  ViewController.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 8/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "ViewController.h"
#import "SCUI.h"

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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=54c6dc48849142fea3eac3be32d3ca28&redirect_uri=photosound://instagram_auth&response_type=code"]];
}

- (IBAction)uploadButtonPressed:(id)sender {
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
