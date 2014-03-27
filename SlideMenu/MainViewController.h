//
//  MainViewController.h
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic) NSTimer *musicTimer;
@property (nonatomic) NSTimer *countdownTimer;

- (void)stopMusicTimer;
- (void)stopCountdownTimer;

@end
