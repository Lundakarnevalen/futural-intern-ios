//
//  IDViewController.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "IDViewController.h"

#import "Sektioner.h"

@implementation IDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [self.cardView.layer setCornerRadius:10.0];

    Karnevalist *k = self.api.karnevalist;
    
    self.karnevalistImage.image = [k profilePicture];
    [self.headerLabel setFont:[UIFont fontWithName:@"Robot!Head" size:self.headerLabel.font.pointSize]];
    [self.activeStamp setHidden:!k.active];
    
    [self.personnrLabel setText:[NSString stringWithFormat:@"Personnr: %@", k.personnr]];
    [self.addressLabel setText:[NSString stringWithFormat:@"Gatuadress: %@", k.gatuadress]];
    [self.postAddressLabel setText:[NSString stringWithFormat:@"Postadress: %@ %@", k.postnr, k.postort]];
    [self.nameLabel setText:[NSString stringWithFormat:@"Namn: %@ %@", k.firstname, k.lastname]];
    [self.sektionsLabel setText:[NSString stringWithFormat:@"Sektion: %@", [Sektioner nameFromIdentifier:k.sektion]]];

}

- (FuturalAPI *)api {
    
    if(!_api) {
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
    }
    
    return _api;
    
}

@end
