//
//  MainViewController.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "MainViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"


@interface MainViewController ()


@end

@implementation MainViewController

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}



@end
