//
//  Identification.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-19.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Identification.h"

@interface Identification() {
    
    //DatabaseManager *database;
    
}

@end

@implementation Identification

@synthesize token = _token; //because I implemented the getter and setter myself.

- (Identification *)initAndCheckForExistingToken {
    
    self = [super init];
    
    if(self) {
        
        //database = [DatabaseManager sharedInstance];
       
        if([self tokenExists]) { //check in the database if there's a stored token.
            
            self.token = [self databaseToken];
            
        }
        
    }
    
    return self;
    
}

- (void)setTokenFromDictionary:(NSDictionary *)dictionary {
    
    //todo after master merge (intern-web).
    
}

- (void)destroy { //remove token from database and class.
    
    self.token = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self.class tokenIdentifier]];
    
}

- (void)setToken:(NSString *)token { //setter
    
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:[self.class tokenIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)token { //getter
    
    if(!_token) { //important, or the token won't sync across every API-instantiation (doesn't work at login first-time otherwise). (sucks).
        
        if([self databaseToken]) { //if the database stores a token, GET IT.
            
            _token = [self databaseToken];
            
        }
        
    }
    
    return _token;
    
}

- (NSString *)databaseToken {
    
    return [[NSUserDefaults standardUserDefaults] stringForKey:[self.class tokenIdentifier]];
    //return [database token];
    
}

- (BOOL)tokenExists {
    
    return [self databaseToken] != nil;
    
    //return ([database token] != nil);
    
}

+ (NSString *)tokenIdentifier { //the responsible key storing our user-token in NSUserDefaults.
    
    return @"token"; //easily changeable.
    
}

@end
