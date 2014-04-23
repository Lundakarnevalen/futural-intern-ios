//
//  ReadMessageViewController.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "ReadMessageViewController.h"
#import "ECSlidingViewController.h"
#import "Sektioner.h"

@implementation ReadMessageViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.title = self.currentMessage.title;
    [self.header setText:self.currentMessage.title];
    
    Sektioner *sektion = [[Sektioner sektioner] objectForKey:[NSString stringWithFormat:@"%d", (int) self.currentMessage.recipientId]];
    self.sektionLabel.text = sektion.name;
    self.sektionImageView.image = [UIImage imageNamed:sektion.img];
    
    [self.dateLabel setText:[self.currentMessage dateAsHumanReadableString]];
    [self.informationField setText:self.currentMessage.message];
    
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
