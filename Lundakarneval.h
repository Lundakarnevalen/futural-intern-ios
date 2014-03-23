//
//  Lundakarneval.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-19.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lundakarneval : NSObject

+ (NSString *)timeLeftUntil:(NSString *)eventIdentifier; //format: d:h:m
+ (NSDictionary *)eventIdentifiers; //every event will be stored in this dictionary.

@end
