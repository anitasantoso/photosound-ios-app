//
//  InstagramNetworkService.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "InstagramNetworkService.h"
#import "JTSingleton.h"
#import "AFHTTPClient.h"
#import "AFNetworking.h"

#define kClientID @"54c6dc48849142fea3eac3be32d3ca28"
#define kClientSecret @"35fc261cd7a94effa60d6818a5af8641"

#define kInstaAccessTokenKey @"PS_INSTA_ACCESS_TOKEN"
#define kInstaUserID @"PS_INSTA_USER_ID"

@interface InstagramNetworkService()
@property (nonatomic, strong) AFHTTPClient *client;

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) InstagramUser *user;
@end

@implementation InstagramNetworkService

JTSYNTHESIZE_SINGLETON_FOR_CLASS(InstagramNetworkService)

- (id)init {
    if(self = [super init]) {
        self.client = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com"]];
    }
    return self;
}

- (void)checkAuthentication {
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]stringForKey:kInstaAccessTokenKey];
    NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:kInstaUserID];
    
    self.accessToken = accessToken;
    self.userID = userID;
    
    [InstagramNetworkService sharedInstance].isAuthenticated = accessToken != nil && userID != nil;
}

- (void)authenticate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize/?client_id=54c6dc48849142fea3eac3be32d3ca28&redirect_uri=photosound://instagram_auth&response_type=code"]];
}

/**
 curl -F 'client_id=54c6dc48849142fea3eac3be32d3ca28' -F 'client_secret=35fc261cd7a94effa60d6818a5af8641' -F 'grant_type=authorization_code' -F 'redirect_uri=photosound://' -F 'code=f1515d059cc443b99454d02aa9e1fccf' https://api.instagram.com/oauth/access_token
 **/
- (void)requestAccessTokenWithCompletion:(void (^)(id responseObject))completionBlock error:(void (^)(NSString *errorMsg))errorBlock{
    
    NSDictionary *params = @{@"client_id" : kClientID, @"client_secret" : kClientSecret, @"grant_type" : @"authorization_code", @"redirect_uri" :   @"photosound://instagram_auth", @"code" : self.apiCode};
    

    NSURLRequest *request = [self.client requestWithMethod:@"POST" path:@"/oauth/access_token" parameters:params];
    
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(0);
        self.accessToken = [JSON objectForKey:@"access_token"];
        NSDictionary *userInfo = [JSON objectForKey:@"user"];
        self.user = [[InstagramUser alloc]initWithDictionary:userInfo];
        
        // store to UserDefaults
        [[NSUserDefaults standardUserDefaults]setValue:self.accessToken forKey:kInstaAccessTokenKey];
        [[NSUserDefaults standardUserDefaults]setValue:self.self.user.userID forKey:kInstaUserID];
        
        completionBlock(nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        errorBlock(nil);
        NSLog(0);
    }];
    [self.client enqueueHTTPRequestOperation:op];
}

- (void)fetchUserMediaWithCompletion:(void (^)(NSArray *imageURLs))completionBlock error:(void (^)(NSString *errorMsg))errorBlock{
    
    void (^fetchUserMedia)(void) = ^(void) {
        
        NSURLRequest *request = [self.client requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/v1/users/%@/media/recent/", self.user.userID] parameters:@{@"access_token" : self.accessToken}];
        
        // store image urls
        AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSArray *data = [JSON objectForKey:@"data"];
            NSMutableArray *imgURLs = [[NSMutableArray alloc]initWithCapacity:[data count]];
            for(id imageData in data) {
                NSDictionary *images = [imageData objectForKey:@"images"];
                
                // get standard res images
                NSDictionary *standardResImg = [images objectForKey:@"standard_resolution"];
                NSString *imgURL = [standardResImg objectForKey:@"url"];
                [imgURLs addObject:imgURL];
            }
            
            // update user object
            self.user.imageURLs = [imgURLs mutableCopy];
            
            // call completion
            completionBlock(self.user.imageURLs);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            errorBlock(nil);
        }];
        [self.client enqueueHTTPRequestOperation:op];
    };
    
    // if we don't have a user
    if(![InstagramNetworkService sharedInstance].user) {
        
        // fetch user
        [[InstagramNetworkService sharedInstance]fetchUserWithCompletion:^(InstagramUser *user) {
            
            // then grab media
            fetchUserMedia();
        } error:^(NSString *errorMsg) {
            errorBlock(nil);
        }];
    } else {
        fetchUserMedia();
    }
}

@end
