//
//  LyricString.m
//  lyric
//
//  Created by Richard Luong on 2014-03-23.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "LyricString.h"

@implementation LyricString

- (id)initWithString:(NSString *)str time:(double)time {
    
    self = [[LyricString alloc] init];
    
    if (self) {
        self.str = str;
        self.time = time;
    }
    
    return self;
}

@end
