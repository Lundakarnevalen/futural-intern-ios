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

+(NSArray *)sektioner {
    
    NSMutableArray *sektioner = [[NSMutableArray alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"sektioner" ofType:@"plist"];
    
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *tempSektioner = [temp objectForKey:@"sektioner"];
    
    for (id obj in tempSektioner) {
        Sektioner *sektion = [[Sektioner alloc] init];
        sektion.name = [obj objectForKey:@"name"];
        sektion.answer1 = [obj objectForKey:@"answer1"];
        sektion.answer2 = [obj objectForKey:@"answer2"];
        sektion.answer3 = [obj objectForKey:@"answer3"];
        sektion.answer4 = [obj objectForKey:@"answer4"];
        sektion.img = [obj objectForKey:@"img"];
        
        [sektioner addObject:sektion];
    }
    
    return [sektioner copy];
}

@end
