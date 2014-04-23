//
//  UIButton+CustomFont+Shadow.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "UIButton+CustomFont.h"

@implementation UIButton_CustomFont

-(id)init {
    self = [super init];
    if (self) {
        [self.titleLabel setFont:[UIFont fontWithName:@"FuturaLT-Bold" size:self.titleLabel.font.pointSize]];
        self.titleLabel.text = [self.titleLabel.text uppercaseString];
    }
    return self;
}

@end
