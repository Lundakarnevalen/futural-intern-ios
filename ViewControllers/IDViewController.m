//
//  IDViewController.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "IDViewController.h"
#import "ECSlidingViewController.h"

#import "Sektioner.h"

@interface IDViewController()

@property (weak, nonatomic) IBOutlet UIImageView *clouds;

@end

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

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self animate];
}

-(void)animate {
    
    [UIView animateWithDuration:10.0
                          delay:0.1
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         CGPoint center = self.clouds.center;
                         center.x -= 100;
                         self.clouds.center = center;
                     }
                     completion:^(BOOL finished){ }];
}

- (FuturalAPI *)api {
    
    if(!_api) {
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
    }
    
    return _api;
    
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
