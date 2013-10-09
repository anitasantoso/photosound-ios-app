//
//  AppDelegate.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 8/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "InstagramNetworkService.h"
#import "SoundCloudNetworkService.h"
#import "PhotoCollectionViewController.h"
#import "LoadingView.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // check for existing auth
    [[SoundCloudNetworkService sharedInstance]authenticate];
    [[InstagramNetworkService sharedInstance]checkAuthentication];
    
    // show this initially
    [self showLoginView];
    
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSString *urlString = [url absoluteString];
    
    // instagram auth
    if([urlString rangeOfString:@"instagram_auth"].location != NSNotFound) {
        NSString *codeParam = @"code=";
        NSRange range = [urlString rangeOfString:codeParam];
        if(range.location != NSNotFound) {
            int location = range.location+codeParam.length;
            NSString *apiCode = [urlString substringWithRange:NSMakeRange(location, [urlString length]-location)];
            
            [InstagramNetworkService sharedInstance].apiCode = apiCode;
            [InstagramNetworkService sharedInstance].isAuthenticated = YES;
        }
    }
    
    [self.window.rootViewController performSelector:@selector(updateAuthenticationStatus) withObject:nil];
    return YES;
}

- (void)showLoginView {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *viewCon = (ViewController*)[storyboard instantiateInitialViewController];
    self.window.rootViewController = viewCon;
}

- (void)showPhotoCollectionView {
    
    [LoadingView show];
    [[InstagramNetworkService sharedInstance]fetchUserMediaWithCompletion:^(NSArray *imgURLs) {
        
        [LoadingView hide];
        
        // TODO hide spinner here
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        PhotoCollectionViewController *viewCon = (PhotoCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PhotoCollectionViewController"];
        viewCon.imageURLs = imgURLs;
        self.window.rootViewController = viewCon;
    } error:^(NSString *errorMsg) {
        
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
