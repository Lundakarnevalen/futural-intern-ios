//
//  ViewControllerEasterEgg.m
//  Karnevalist2014
//
//  Created by Richard Luong on 2014-01-30.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "ViewControllerEasterEgg.h"

@interface ViewControllerEasterEgg ()

@end

@implementation ViewControllerEasterEgg

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *myWeview = [NSURL URLWithString:@"http://www.youtube.com/embed/oHg5SJYRHA0"];
    
    NSURLRequest *myrequest = [NSURLRequest requestWithURL:myWeview];
    
    [myWebView loadRequest:myrequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
