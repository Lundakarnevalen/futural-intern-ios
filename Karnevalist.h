//
//  Karnevalist.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-21.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Identification.h"

@interface Karnevalist : NSObject

@property (nonatomic) Identification *identification;

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSDate *birthday;

@property (nonatomic) NSString *firstname;
@property (nonatomic) NSString *lastname;
@property (nonatomic) NSString *email;

@property (nonatomic) NSString *sektion;

@property (nonatomic) NSURL *imageUrl;

- (NSString *)token;
- (void)setToken:(NSString *)token;
- (void)setInformationFromDictionary:(NSDictionary *)dictionary;

@end
