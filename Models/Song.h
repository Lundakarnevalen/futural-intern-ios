//
//  Songs.h
//  Karnevalisten
//
//  Created by Lisa Ellerstedt on 2014-03-30.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property NSString *name;
@property NSString *melodi;
@property NSString *text;
@property NSString *category;
@property BOOL isWinner;
@property UIImage *img;
@property NSNumber *pageNumber;

//designated init
-(instancetype)initWithDictionary:(NSDictionary *)dict;

+(UIImage *)imageForCategoryWithName:(NSString *)category;

@end
