//
//  UILabel+CustomFont.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "UILabel+CustomFont.h"

@implementation UILabel_CustomFont

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self setFont:[UIFont fontWithName:@"FuturaLT-Bold" size:self.font.pointSize]];
    self.text = [self.text uppercaseString];
    //[self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    [super drawRect:rect];
    
    // Drawing code
}

@end
