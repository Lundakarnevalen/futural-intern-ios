//
//  Cluster.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-27.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Cluster.h"

@implementation Cluster

@synthesize identifier = _identifier;

- (Cluster *)initWithIdentifier:(NSString *)identifier andPositionOf:(CLLocation *)location {
    
    self = [super init];
    
    if(self) {
        
        self.identifier = identifier;
        self.position = location;
        
    }
    
    return self;
    
}

- (Cluster *)initWithStoredIdentifier {
    
    self = [super init];
    
    if(self) {
        
        [self setStoredIdentifier];
        
    }
    
    return self;
    
}

- (void)setStoredIdentifier {
    
    NSString *storedIdentifier = [self getStoredIdentifier];
    
    if(storedIdentifier) {
        
        self.identifier = storedIdentifier;
        
    }
    
}

- (NSString *)getStoredIdentifier {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:[[self class] stringIdentifierForStoredCluster]];
    
}

- (NSString *)identifier {
    
    if(!_identifier) { //to be synced across all of the instantiations.
        
        if([self getStoredIdentifier]) {
            
            _identifier = [self getStoredIdentifier];
            
        }
        
    }
    
    return _identifier;
    
}

- (void)setIdentifier:(NSString *)identifier {
    
    NSLog(@"set and stored identifier %@", identifier);
    
    _identifier = identifier;
    [self storeIdentifier];
    
}

- (void)storeIdentifier {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.identifier forKey:[[self class] stringIdentifierForStoredCluster]];
    
}

- (void)destoryIdentifier {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[[self class] stringIdentifierForStoredCluster]];
    self.identifier = nil;
    
}

- (BOOL)isAvailable {
    
    return self.identifier != nil;
    
}

+ (NSString *)stringIdentifierForStoredCluster {
    
    return @"cluster_id";
    
}

@end
