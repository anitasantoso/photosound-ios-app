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
#import "SoundCloudNetworkService.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (strong, nonatomic) IBOutlet UIButton *soundCloudLoginButton;
@property (strong, nonatomic) IBOutlet UIImageView *scLoginTick;
@property (strong, nonatomic) IBOutlet UIImageView *instaLoginTick;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation ViewController

- (IBAction)loginButtonPressed:(id)sender {
    if(![SoundCloudNetworkService sharedInstance].isAuthenticated) {
        [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
            SCLoginViewController *loginViewController = [SCLoginViewController
                                                          loginViewControllerWithPreparedURL:preparedURL
                                                          completionHandler:^(NSError *error) {
                                                              self.scLoginTick.hidden = NO;
                                                              [SoundCloudNetworkService sharedInstance].isAuthenticated = YES;
                                                          }];
            [self presentViewController:loginViewController animated:YES completion:nil];
        }];
    } else {
        // TODO
    }
    
    /** get tracks
    
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            SCTTrackListViewController *trackListVC;
            trackListVC = [[SCTTrackListViewController alloc]
                           initWithNibName:@"SCTTrackListViewController"
                           bundle:nil];
            trackListVC.tracks = (NSArray *)jsonResponse;
            [self presentViewController:trackListVC
                               animated:YES completion:nil];
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/tracks.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    **/
    
    /**
     play sound
     NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
     NSString *streamURL = [track objectForKey:@"stream_url"];
     
     SCAccount *account = [SCSoundCloud account];
     
     [SCRequest performMethod:SCRequestMethodGET
     onResource:[NSURL URLWithString:streamURL]
     usingParameters:nil
     withAccount:account
     sendingProgressHandler:nil
     responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
     NSError *playerError;
     player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
     [player prepareToPlay];
     [player play];
     }];
     **/
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
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *soundFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
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
                           shareViewControllerWithFileURL:soundFileURL
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

//- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
////    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
////    
////    [stopButton setEnabled:NO];
////    [playButton setEnabled:YES];
//}

- (void)updateAuthenticationStatus {
    self.scLoginTick.hidden = ![SoundCloudNetworkService sharedInstance].isAuthenticated;
    self.instaLoginTick.hidden = ![InstagramNetworkService sharedInstance].isAuthenticated;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateAuthenticationStatus];
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
