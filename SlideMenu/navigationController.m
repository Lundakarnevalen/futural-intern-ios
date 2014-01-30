//
//  navigationController.m
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-30.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "navigationController.h"

@implementation navigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Nav_bar.png"] forBarMetrics:UIBarMetricsDefault];

    
}


@end
