//
//  LyricString.h
//  lyric
//
//  Created by Richard Luong on 2014-03-23.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricString : NSObject

@property NSString *str;
@property double time;

- (id)initWithString:(NSString *)str time:(double)time;

@end




