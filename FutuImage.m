//
//  FutuImage.m
//  Camera
//
//  Created by Richard Luong on 2014-04-27.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "FutuImage.h"

@implementation FutuImage

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.caption = dict[@"caption"];
        self.url = [NSURL URLWithString:dict[@"url"]];
        self.thumb = dict[@"thumb"];
        self.name = dict[@"name"];
    }
    return self;
}

@end
