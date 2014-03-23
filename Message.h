//
//  Message.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-17.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *message;
@property (nonatomic) NSDate *updatedAt;
@property (nonatomic) NSDate *postedAt;

- (Message *)initWithDictionary:(NSDictionary *)container; //designated initializer
- (NSString *)dateAsHumanReadableString;

@end
