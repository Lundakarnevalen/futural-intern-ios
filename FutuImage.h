//
//  FutuImage.h
//  Camera
//
//  Created by Richard Luong on 2014-04-27.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FutuImage : NSObject

@property (nonatomic) NSURL *thumb;
@property (nonatomic) NSString *caption;
@property (nonatomic) NSString *name;
@property (nonatomic) NSURL *url;

-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
