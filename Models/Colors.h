//
//  Colors.h
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-19.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Colors : NSObject 

+(UIColor *)redColorWithAlpha:(CGFloat)alpha;
+(UIColor *)blueColorWithAlpha:(CGFloat)alpha;
+(UIColor *)yellowColorWithAlpha:(CGFloat)alpha;
+(UIColor *)darkBlueColorWithAlpha:(CGFloat)alpha;
+(UIColor *)lightBlueColorWithAlpha:(CGFloat)alpha;
+(UIColor *)bieghColorWithAlpha:(CGFloat)alpha;

+(UIColor *)randomColorWithAlpha:(CGFloat)alpha;

@end

