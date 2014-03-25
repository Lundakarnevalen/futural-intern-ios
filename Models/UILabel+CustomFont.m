//
//  UILabel+CustomFont.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "UILabel+CustomFont.h"

@implementation UILabel_CustomFont

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
