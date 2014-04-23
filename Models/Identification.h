//
//  Identification.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-19.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identification : NSObject

@property (nonatomic) NSString *token;

- (Identification *)initAndCheckForExistingToken;

- (BOOL)tokenExists;
- (void)destroy;

+ (NSString *)tokenIdentifier;

@end
