//
//  Karnevalist.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-21.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Karnevalist.h"
#import "FuturalAPI.h"

@implementation Karnevalist

- (void)setInformationFromDictionary:(NSDictionary *)dictionary {
    
    NSLog(@"dictionary with karnevalist data: \n%@", dictionary);
    
}

- (NSString *)token {
    
    return self.identification.token;
    
}

- (void)setToken:(NSString *)token {
    
    self.identification.token = token;
    
}

- (Identification *)identification {
    
    if(!_identification) {
        
        _identification = [[Identification alloc] initAndCheckForExistingToken];
        
    }
    
    return _identification;
    
}

@end
