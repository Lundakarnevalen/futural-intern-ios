//
//  IDViewController.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "IDViewController.h"

@implementation IDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [self.cardView.layer setCornerRadius:10.0];
    
    NSURL *profileImageUrl = [NSURL URLWithString:self.api.karnevalist.imageUrl];
    NSLog(@"url: %@", self.api.karnevalist.imageUrl);
    self.karnevalistImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:profileImageUrl]];
    [self.headerLabel setFont:[UIFont fontWithName:@"Robot!Head" size:36]];
    //[self.activeStamp setHidden:!self.api.karnevalist.active];
    [self.nameLabel setText:[NSString stringWithFormat:@"%@ %@", self.api.karnevalist.firstname, self.api.karnevalist.lastname]];
    [self.sektionsLabel setText:[NSString stringWithFormat:@"%@", self.api.karnevalist.sektion]];

}

- (FuturalAPI *)api {
    
    if(!_api) {
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
    }
    
    return _api;
    
}

@end
