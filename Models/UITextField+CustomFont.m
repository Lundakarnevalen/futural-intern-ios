//
//  UITextField+CustomFont.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "UITextField+CustomFont.h"

@implementation UITextField_CustomFont

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setFont:[UIFont fontWithName:@"FuturaLT-Bold" size:self.font.pointSize]];
    self.text = [self.text uppercaseString];
    //[self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]];
    [super drawRect:rect];
    
    // Drawing code
}

@end
