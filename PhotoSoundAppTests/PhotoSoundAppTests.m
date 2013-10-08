//
//  PhotoSoundAppTests.m
//  PhotoSoundAppTests
//
//  Created by Anita Santoso on 8/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"
#import "InstagramNetworkService.h"

SPEC_BEGIN(InstagramServiceSpec)

describe(@"Async test", ^{
    it(@"Should exercise instagram authentication", ^{
        
        __block NSNumber *returnVal;
        [[InstagramNetworkService sharedInstance]requestTokenForClientID:@"54c6dc48849142fea3eac3be32d3ca28" completion:^(BOOL success) {
            returnVal = [NSNumber numberWithBool:success];
        }];
        [[expectFutureValue(returnVal) shouldEventuallyBeforeTimingOutAfter(10)]equal:[NSNumber numberWithBool:YES]];
    });
  
});
SPEC_END
