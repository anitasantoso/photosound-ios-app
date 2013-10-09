//
//  InstagramNetworkService.h
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstagramUser.h"

@interface InstagramNetworkService : NSObject

+ (InstagramNetworkService*)sharedInstance;
@property (nonatomic, strong) NSString *apiCode;
- (void)checkAuthentication;
- (void)authenticate;
- (void)fetchUserWithCompletion:(void (^)(InstagramUser *user))completionBlock error:(void (^)(NSString *errorMsg))errorBlock;
- (void)fetchUserMediaWithCompletion:(void (^)(NSArray *imageURLs))completionBlock error:(void (^)(NSString *errorMsg))errorBlock;;
@property BOOL isAuthenticated;

@end
