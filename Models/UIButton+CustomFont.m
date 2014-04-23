//
//  UIButton+CustomFont+Shadow.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "UIButton+CustomFont.h"

@implementation UIButton_CustomFont

- (void)drawRect:(CGRect)rect
{
    [self.titleLabel setFont:[UIFont fontWithName:@"FuturaLT-Bold" size:self.titleLabel.font.pointSize]];
    self.titleLabel.text = [self.titleLabel.text uppercaseString];
    //[self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    [super drawRect:rect];
    
    // Drawing code
}

@end
