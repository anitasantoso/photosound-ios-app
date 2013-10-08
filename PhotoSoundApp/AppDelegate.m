//
//  AppDelegate.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 8/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "AppDelegate.h"
#import "SCUI.h"
#import "ViewController.h"
#import "InstagramNetworkService.h"
#import "PhotoCollectionViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    [SCSoundCloud setClientID:@"56864d0f3d29077a654b993540815ea7" secret:@"ec967e80f3ea5554200a90773ec3020e" redirectURL:[NSURL URLWithString:@"photosound://"]];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ViewController *viewCon = (ViewController*)[storyboard instantiateInitialViewController];
//    self.window.rootViewController = viewCon;
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // instagram auth
    NSString *urlString = [url absoluteString];
    NSString *codeParam = @"code=";
    NSRange range = [urlString rangeOfString:codeParam];
    if(range.location != NSNotFound) {
        int location = range.location+codeParam.length;
        NSString *apiCode = [urlString substringWithRange:NSMakeRange(location, [urlString length]-location)];
        
        [InstagramNetworkService sharedInstance].apiCode = apiCode;
        [[InstagramNetworkService sharedInstance]fetchUserMediaWithCompletion:^(InstagramUser *user) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            PhotoCollectionViewController *viewCon = (PhotoCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PhotoCollectionViewController"];
            viewCon.imageURLs = user.imageURLs;
            self.window.rootViewController = viewCon;   
        }];
    }
    NSLog(@"%@", url);
    return YES;
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
