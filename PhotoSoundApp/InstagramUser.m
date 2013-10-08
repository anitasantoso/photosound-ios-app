//
//  InstagramUser.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "InstagramUser.h"

@implementation InstagramUser

- (id)initWithDictionary:(NSDictionary*)dict {
    if(self = [super init]) {
        self.userID = [dict objectForKey:@"id"];
        self.username = [dict objectForKey:@"username"];
        self.profilePicURL = [dict objectForKey:@"profile_picture"];
    }
    return self;
}

@end
