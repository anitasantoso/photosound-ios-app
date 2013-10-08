//
//  PhotoViewController.m
//  PhotoSoundApp
//
//  Created by Anita Santoso on 9/10/13.
//  Copyright (c) 2013 as. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setImgURL:(NSString *)imgURL {
    _imgURL = imgURL;
    NSRange lastSlash = [imgURL rangeOfString:@"/" options:NSBackwardsSearch];
    self.imgName = [imgURL substringWithRange:NSMakeRange(lastSlash.location, imgURL.length-lastSlash.location)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:@"PhotoSoundDictionary"];
    if([dict objectForKey:self.imgName]) {
        // TODO show bubble icon
    } else {
        // TODO show record icon
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
