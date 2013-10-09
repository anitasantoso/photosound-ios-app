//
//  SoundCloudNetworkService.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "SoundCloudNetworkService.h"
#import "SCUI.h"
#import "AFNetworking.h"

@interface SoundCloudNetworkService()
@property (nonatomic, strong) AFHTTPClient *client;
@end

@implementation SoundCloudNetworkService

JTSYNTHESIZE_SINGLETON_FOR_CLASS(SoundCloudNetworkService)

- (id)init {
    if(self = [super init]) {
        self.client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.soundcloud.com"]];
    }
    return self;
}

- (void)upload {
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
    
    // TODO
//    [self presentModalViewController:shareViewController animated:YES];
}

- (void)authenticate {
    [SCSoundCloud setClientID:@"56864d0f3d29077a654b993540815ea7" secret:@"ec967e80f3ea5554200a90773ec3020e" redirectURL:[NSURL URLWithString:@"photosound://soundcloud_auth"]];
    
    [SoundCloudNetworkService sharedInstance].isAuthenticated = [SCSoundCloud account] != nil;
}

@end
