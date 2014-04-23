//
//  Cluster.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-27.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface Cluster : NSObject

@property (nonatomic) CLLocation *position;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSInteger *quantity;


- (Cluster *)initWithIdentifier:(NSString *)identifier andPositionOf:(CLLocation *)location;
- (Cluster *)initWithStoredIdentifier; //fetches the cluster-id from NSUserDefaults
- (Cluster *)initWithDictionary:(NSDictionary *)cluster;

- (void)destoryIdentifier;
- (BOOL)isAvailable;

@end
