//
//  Karnevalist.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-21.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Karnevalist.h"
#import "FuturalAPI.h"

#import "ViewControllerSignIn.h"

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
    self.gatuadress = dictionary[@"gatuadress"];
    self.postort = dictionary[@"postort"];
    self.postnr = dictionary[@"postnr"];
    self.personnr = dictionary[@"personnummer"];
    self.gender = [dictionary[@"kon_id"] integerValue];
    self.email = dictionary[@"email"];
    self.phone = dictionary[@"telnr"];
    self.sektion = [dictionary[@"tilldelad_sektion"] integerValue];
    self.imageUrl = dictionary[@"foto"][@"url"]; //to be continued.
    self.active = dictionary[@"active"];
    
    NSLog(@"%@", dictionary);
    
    if(save) {
        
        [self saveData];
        
    }
    
}

- (BOOL)isStoredDataUpToDate {
    
    NSDictionary *data = [self readData];
    return (data[@"active"] != nil && data[@"personnummer"] != nil); //keep on adding if the karnevalist fields are updated.
    
}

- (void)saveData {
    
    NSDictionary *dataToSave = @{
                                 @"id": [NSNumber numberWithInteger:self.identifier],
                                 @"active": [NSNumber numberWithBool:self.active],
                                 @"fornamn": self.firstname,
                                 @"efternamn": self.lastname,
                                 @"email": self.email,
                                 @"telnr": self.phone,
                                 @"tilldelad_sektion": [NSNumber numberWithInt:self.sektion],
                                 @"foto": @{ @"url" : self.imageUrl},
                                 @"postnr" : self.postnr,
                                 @"gatuadress" : self.gatuadress,
                                 @"postort" : self.postort,
                                 @"personnummer" : self.personnr,
                                 @"gender" : [NSNumber numberWithInteger:self.gender]
                                 };
    
    [[NSUserDefaults standardUserDefaults] setValue:dataToSave forKey:@"karnevalist"];
    
}

- (void)destroyData {
    
    [self.identification destroy];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[[self class] userIdentifier]]; //remove data from nsuserdefaults.
    
    self.firstname = nil;
    self.active = NO;
    self.lastname = nil;
    self.sektion = 0;
    self.email = nil;
    self.phone = nil;
    self.identifier = nil;
    self.postort = nil;
    self.postnr = nil;
    self.gender = 0;
    self.gatuadress = nil;
    self.personnr = nil;
    
    NSString *imagePath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"_profileImage.jpeg"];
    [[[NSFileManager alloc] init] removeItemAtPath:imagePath error:nil];
    
}

- (UIImage *)profilePicture {
    
    NSString *imagePath = [[self applicationDocumentsDirectory].path stringByAppendingPathComponent:@"_profileImage.jpeg"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    if(!imageData) { //download and cache the image.
    
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSLog(@"downloading profile image.");
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        
        if(imageData) { //if there's an image, store it (may crash if not checked).
            NSLog(@"cached profile image.");
            [fileManager createFileAtPath:imagePath contents:imageData attributes:nil];
        }
        
    } else {
        NSLog(@"Found cached profile image.");
    }
    
    return [UIImage imageWithData:imageData];
    
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSDictionary *)readData {
    
    return [[NSUserDefaults standardUserDefaults] valueForKey:[[self class] userIdentifier]];
    
}

- (NSString *)description { //debug.
    
    return [NSString stringWithFormat:@"Hej, mitt namn är %@ %@ och jag är med i sektion %@. Jag har identifier %d och är såhär aktiv: %d", self.firstname, self.lastname, self.sektion, self.identifier, self.active];
    
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
