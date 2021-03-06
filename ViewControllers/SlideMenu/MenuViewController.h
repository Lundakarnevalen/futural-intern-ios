//
//  MenuViewController.h
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FuturalAPI.h"

@interface MenuViewController : UITableViewController <NSURLConnectionDataDelegate>

@property (nonatomic) FuturalAPI *api;

- (void)destroyCache;

@end
