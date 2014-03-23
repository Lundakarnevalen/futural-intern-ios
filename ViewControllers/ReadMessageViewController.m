//
//  ReadMessageViewController.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "ReadMessageViewController.h"

@implementation ReadMessageViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.title = self.currentMessage.title;
    [self.header setText:self.currentMessage.title];
    
    
    [self.dateLabel setText:[self.currentMessage dateAsHumanReadableString]];
    [self.informationField setText:self.currentMessage.message];
    
}

@end
