//
//  IDViewController.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainViewController.h"
#import "FuturalAPI.h"

@interface IDViewController : UIViewController <NSURLConnectionDataDelegate>


@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeStamp;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeHandler;

@property (weak, nonatomic) IBOutlet UIImageView *karnevalistImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personnrLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *postAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *sektionsLabel;
@property (nonatomic) FuturalAPI *api;

@end
