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

- (void)authenticate;
- (void)fetchUserMediaWithCompletion:(void (^)(InstagramUser *user))completionBlock;
@property BOOL isAuthenticated;

@end
