//
//  navigationController.m
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-30.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "NavigationController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "Colors.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.slidingViewController.underLeftViewController  = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"FuturaLT-Bold" size:17.0], NSFontAttributeName, nil]];
    
    self.navigationBar.topItem.title = [self.navigationBar.topItem.title uppercaseString];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [[UINavigationBar appearance] setBarTintColor:[Colors darkBlueColorWithAlpha:1]];
        self.navigationBar.translucent = NO;
    } else {
        [self.navigationBar setTintColor:[Colors darkBlueColorWithAlpha:1]];
    }
}

@end
