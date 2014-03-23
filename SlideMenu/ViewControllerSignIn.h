//
//  ViewControllerWebView.h
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-29.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FuturalAPI.h"

@interface ViewControllerSignIn : UIViewController <NSURLConnectionDataDelegate, UITextFieldDelegate>

@property (nonatomic) FuturalAPI *api;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
