//
//  FuturalAPI.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-17.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

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

- (void)fetchNotifications; //get messages.
- (void)fetchMapCoordinates; //get coordinates from other karnevalists
- (void)fetchImages; //get all images for the futugram
- (void)authenticateUser:(NSString *)userIdentification withPassword:(NSString *)password; //sign in user
- (void)signOut;
- (void)resetPassword:(NSString *)email;
- (void)updateLocation:(CLLocation *)location; //upload coordinates to server.
- (void)sendAppleToken:(NSString *)token;

+ (NSDictionary *)parseJSONData:(NSData *)jsonData;
+ (NSString *)stringIdentifierFromUrlConnection:(NSURLConnection *)connection; //get identifier from connection.
+ (NSString *)methodFromURLConnection:(NSURLConnection *)connection; //get http method from connection.

@end
