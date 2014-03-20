//
//  MapViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-18.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MapViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
