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
    
    BOOL dataIsUpToDate = [self.api.karnevalist isStoredDataUpToDate];
    
    NSString *storyboardIdentifier = ([self.api isSignedIn] == YES && dataIsUpToDate == YES) ? @"Start" : @"Logga in";
    
    if([self.api isSignedIn] && dataIsUpToDate) { //fulfix för att se om karnevalisten är aktiv eller inte (vilket kräver att du loggar in igen).
        storyboardIdentifier = @"Start";
    } else {
        [self.api.karnevalist destroyData];
        storyboardIdentifier = @"Logga in";
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardIdentifier bundle:nil];
    self.topViewController = [storyboard instantiateInitialViewController];
    
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
