//
//  BarnevalViewController.m
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-23.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "BarnevalViewController.h"


@interface BarnevalViewController ()

@end

@implementation BarnevalViewController

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
	
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(print_Message)];
    
    
    
}

-(void)print_Message {
    NSLog(@"test");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
