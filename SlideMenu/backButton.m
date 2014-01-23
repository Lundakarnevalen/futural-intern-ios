//
//  backButton.m
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-23.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "backButton.h"

@implementation backButton



// create button
UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
[backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
[backButton setTitle:@"Back" forState:UIControlStateNormal];

// create button item -- possible because UIButton subclasses UIView!
UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

// add to toolbar, or to a navbar (you should only have one of these!)
[toolbar setItems:[NSArray arrayWithObject:backItem]];
navItem.leftBarButtonItem = backItem;

@end
