//
//  InitViewController.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "InitViewController.h"

#import "FuturalAPI.h"

@interface InitViewController ()

@property (nonatomic) FuturalAPI *api;

@end

@implementation InitViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSString *storyboardIdentifier = ([self.api isSignedIn] == YES) ? @"Start" : @"Logga in";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle:nil];
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
        
    }
    
}

- (FuturalAPI *)api {
    
    if(!_api) {
        
        _api = [[FuturalAPI alloc] init]; //no need to delegate.
        
    }
    
    return _api;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
    
}

@end
