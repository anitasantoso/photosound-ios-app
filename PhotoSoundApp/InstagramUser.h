//
//  InstagramUser.h
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUser : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *profilePicURL;
@property (nonatomic, strong) NSArray *imageURLs;
- (id)initWithDictionary:(NSDictionary*)dict;
@end
