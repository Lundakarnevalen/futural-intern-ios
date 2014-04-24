//
//  RLSektioner.m
//  Lundakarnevalens internapp
//
//  Created by Richard Luong on 2014-01-28.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "Sektioner.h"

@interface Sektioner()

@end

@implementation Sektioner

-(Sektioner *)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.name = [dict objectForKey:@"name"];
        self.answer1 = [dict objectForKey:@"answer1"];
        self.answer2 = [dict objectForKey:@"answer2"];
        self.answer3 = [dict objectForKey:@"answer3"];
        self.answer4 = [dict objectForKey:@"answer4"];
        self.img = [dict objectForKey:@"img"];
    }
    
    return self;
}

+(NSDictionary *)sektioner {
    
    NSMutableDictionary *sektioner = [[NSMutableDictionary alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sektioner" ofType:@"plist"];
    
    NSDictionary *dictionaryFromPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath][@"sektioner"];
    
    NSEnumerator *enumerator = [dictionaryFromPlist keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        NSDictionary *tmp = [dictionaryFromPlist objectForKey:key];
        Sektioner *sektion = [[Sektioner alloc] initWithDictionary:tmp];
        [sektioner setObject:sektion forKey:key];
    }
    
    return [sektioner copy];
}

+ (NSString *)nameFromIdentifier:(NSInteger)identifier {
    
    NSString *name;
    
    NSLog(@"sektion:%d", identifier);
    
    switch(identifier) {
            
        case 10:
            name = @"Kommunikation";
            break;
            
        default:
            name = @"???";
            break;
            
    }
    
    return name;
    
}

@end
