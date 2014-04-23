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
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd mm:ss"]; //change if necessary due to api update (ISO-8601).
        
        //the strings are set from the backend, change if the api is updated.
        id title = container[@"title"];
        id message = container[@"message"];
        id postedAt = container[@"created_at"];
        id updatedAt = container[@"updated_at"];
        id recipientId = [NSNumber numberWithInteger:[container[@"recipient_id"] integerValue]];
        
        if(title && message && postedAt) {
            
            self.title = title;
            self.message = message;
            self.postedAt = [dateFormatter dateFromString:postedAt];
            self.updatedAt = [dateFormatter dateFromString:updatedAt];
            self.recipientId = [recipientId integerValue];
            
        }
        
    }
    
    return self;
    
}

- (NSString *)dateAsHumanReadableString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSLocale *locale = [NSLocale currentLocale];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDoesRelativeDateFormatting:YES]; //human readable strings.
    
    return [dateFormatter stringFromDate:self.postedAt];
    
}

@end
