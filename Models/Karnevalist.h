//
//  Karnevalist.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-21.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Identification.h"
#import "Cluster.h"

@interface Karnevalist : NSObject

@property (nonatomic) Identification *identification; //contains user-token.
@property (nonatomic) Cluster *cluster; //contains location-data.

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSDate *birthday;

@property (nonatomic) NSString *firstname;
@property (nonatomic) NSString *lastname;
@property (nonatomic) BOOL active;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *sektion;
@property (nonatomic) NSString *imageUrl;

@property (nonatomic) NSString *gatuadress;
@property (nonatomic) NSString *postort;
@property (nonatomic) NSString *postnr;
@property (nonatomic) NSString *personnr;
@property (nonatomic) NSInteger gender;

- (NSString *)token;
- (BOOL)isStoredDataUpToDate;
- (void)setToken:(NSString *)token;
- (void)setInformationFromDictionary:(NSDictionary *)dictionary andSave:(BOOL)save;

- (void)destroyData;

- (NSString *)description;

@end
