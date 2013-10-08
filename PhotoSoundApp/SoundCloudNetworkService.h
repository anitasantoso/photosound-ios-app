//
//  SoundCloudNetworkService.h
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTSingleton.h"

@interface SoundCloudNetworkService : NSObject
+ (SoundCloudNetworkService*)sharedInstance;
- (void)authenticate;
@property BOOL isAuthenticated;
@end
