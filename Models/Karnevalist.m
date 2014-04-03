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

- (Karnevalist *)init {
    
    self = [super init];
    
    if(self) {
        
        if([self readData]) {
            
            //read stored data.
            [self setInformationFromDictionary:[self readData] andSave:NO];
            
        }
        
    }
    
    return self;
    
}

- (void)setInformationFromDictionary:(NSDictionary *)dictionary andSave:(BOOL)save {
    
    self.identifier = [dictionary[@"id"] integerValue];
    self.firstname = dictionary[@"fornamn"];
    self.lastname = dictionary[@"efternamn"];
    self.email = dictionary[@"email"];
    self.phone = dictionary[@"telnr"];
    self.sektion = dictionary[@"tilldelad_sektion"];
    //self.imageUrl = [NSURL URLWithString:dictionary[@"foto"][@"url"]]; //to be continued.
    
    if(save) {
        
        [self saveData];
        
    }
    
}

- (void)saveData {
    
    NSDictionary *dataToSave = @{
                                 @"id": [NSNumber numberWithInteger:self.identifier],
                                 @"fornamn": self.firstname,
                                 @"efternamn": self.lastname,
                                 @"email": self.email,
                                 @"telnr": self.phone,
                                 @"tilldelad_sektion": self.sektion
                                 };
    
    [[NSUserDefaults standardUserDefaults] setValue:dataToSave forKey:@"karnevalist"];
    
}

- (void)destroyData {
    
    [self.identification destroy];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[[self class] userIdentifier]]; //remove data from nsuserdefaults.
    
    self.firstname = nil;
    self.lastname = nil;
    self.sektion = nil;
    self.email = nil;
    self.phone = nil;
    self.identifier = nil;
    
}

- (NSDictionary *)readData {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:[[self class] userIdentifier]];
    
}

- (NSString *)description { //debug.
    
    return [NSString stringWithFormat:@"Hej, mitt namn är %@ %@ och jag är med i sektion %@. Jag har identifier %d", self.firstname, self.lastname, self.sektion, self.identifier];
    
}

- (NSString *)token {
    
    return self.identification.token;
    
}

- (void)setToken:(NSString *)token {
    
    self.identification.token = token;
    
}

#pragma mark -LazyInstantiation

- (Identification *)identification {
    
    if(!_identification) {
        
        _identification = [[Identification alloc] initAndCheckForExistingToken];
        
    }
    
    return _identification;
    
}

- (Cluster *)cluster {
    
    if(!_cluster) {
        
        _cluster = [[Cluster alloc] initWithStoredIdentifier];
        
    }
    
    return _cluster;
    
}

#pragma mark -ClassMethods

+ (NSString *)userIdentifier {
    
    return @"karnevalist";
    
}

@end
