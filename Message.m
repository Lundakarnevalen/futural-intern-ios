//
//  Message.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-17.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Message.h"

@implementation Message

- (Message *)initWithDictionary:(NSDictionary *)container { //designated initializer
    
    self = [super init];
    
    if(self) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"]; //change if necessary due to api update (ISO-8601).
        
        //the strings are set from the backend, change if the api is updated.
        id title = container[@"title"];
        id message = container[@"message"];
        id postedAt = container[@"created_at"];
        id updatedAt = container[@"updated_at"];
        
        if(title && message && postedAt) {
            
            self.title = title;
            self.message = message;
            self.postedAt = [dateFormatter dateFromString:postedAt];
            self.updatedAt = [dateFormatter dateFromString:updatedAt];
            
        }
        
    }
    
    return self;
    
}

- (NSString *)dateAsHumanReadableString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDoesRelativeDateFormatting:YES]; //human readable strings.
    
    return [dateFormatter stringFromDate:self.postedAt];
    
}

@end
