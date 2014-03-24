//
//  FuturalAPI.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-17.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Identification.h"
#import "Karnevalist.h"

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FuturalAPI : NSObject

@property (nonatomic) NSURL *url;
@property (nonatomic) NSURLConnection *connection;
//@property (nonatomic) Identification *identification;
@property (nonatomic) Karnevalist *karnevalist;

@property (nonatomic) id<NSURLConnectionDataDelegate> connectionDelegate;

- (FuturalAPI *)initFuturalAPIWithDownloadDelegate:(id<NSURLConnectionDataDelegate>)desiredConnectionDelegate;

- (BOOL)isSignedIn;

- (void)fetchNotifications;
- (void)authenticateUser:(NSString *)userIdentification withPassword:(NSString *)password;
- (void)signOut;
- (void)resetPassword;
- (void)updateLocation:(CLLocation *)location;

+ (NSDictionary *)parseJSONData:(NSData *)jsonData;
+ (NSString *)stringIdentifierFromUrlConnection:(NSURLConnection *)connection;

@end
