//
//  RLSektioner.h
//  Lundakarnevalens internapp
//
//  Created by Richard Luong on 2014-01-28.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sektioner : NSObject

@property NSString *name;
@property NSString *answer1;
@property NSString *answer2;
@property NSString *answer3;
@property NSString *answer4;
@property NSString *img;

-(Sektioner *)initWithDictionary:(NSDictionary *)dict;
+(NSDictionary *)sektioner;
+ (NSString *)nameFromIdentifier:(NSInteger)identifier;

@end
