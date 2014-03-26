//
//  ViewControllerMeddelanden.h
//  Karnevalist2014
//
//  Created by Richard Luong on 2014-01-31.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerMeddelanden : UITableViewController <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (weak, nonatomic) IBOutlet UITableView *messagesTable;

@end
