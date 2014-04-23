//
//  Songs.m
//  Karnevalisten
//
//  Created by Lisa Ellerstedt on 2014-03-30.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Song.h"

@implementation Song

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.melodi = dict[@"melodi"];
        self.text = dict[@"text"];
        self.isWinner = [dict[@"isWinner"] boolValue];
        self.img = [UIImage imageNamed:dict[@"img"]];
        self.pageNumber = dict[@"page_number"];
        self.category = dict[@"category"];
    }
    return self;
}

+(UIImage *)imageForCategoryWithName:(NSString *)category {
    UIImage *image;
    if ([category isEqualToString:@"Karnevalsmelodin"]) {
        image = [UIImage imageNamed:@"Karnevalsmelodin Box"];
    } else if ([category isEqualToString:@"Punschvisor"]) {
        image = [UIImage imageNamed:@"Punschvisor Box"];
    } else if ([category isEqualToString:@"Snapsvisor"]) {
        image = [UIImage imageNamed:@"Snapsvisor Box"];
    } else if ([category isEqualToString:@"Ölvisor"]) {
        image = [UIImage imageNamed:@"Ölvisor Box"];
    } else if ([category isEqualToString:@"Alkoholfria visor"]) {
        image = [UIImage imageNamed:@"Alkoholfria Visor Box"];
    } else {
        image = [UIImage imageNamed:@"Övriga Box"];
    }
    return image;
}

@end
