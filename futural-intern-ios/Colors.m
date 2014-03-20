//
//  Colors.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-19.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+(UIColor *)redColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:240.0/255.0
                           green:83.0/255.0
                            blue:62.0/255.0
                           alpha:alpha];
}

+(UIColor *)blueColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:193.0/255.0
                           green:211.0/255.0
                            blue:238.0/255.0
                           alpha:alpha];
}

+(UIColor *)yellowColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:245.0/255.0
                           green:212.0/255.0
                            blue:8.0/255.0
                           alpha:alpha];
}

+(UIColor *)darkBlueColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:93.0/255.0
                           green:97.0/255.0
                            blue:127.0/255.0
                           alpha:alpha];
}

+(UIColor *)lightBlueColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:195.0/255.0 
                           green:193.0/255.0
                            blue:225.0/255.0
                           alpha:alpha];
}

+(UIColor *)bieghColorWithAlpha:(CGFloat)alpha{
    return [UIColor colorWithRed:247.0/255.0
                           green:234.0/255.0
                            blue:212.0/255.0
                           alpha:alpha];
}

@end


