//
//  Lundakarneval.m
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-19.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "Lundakarneval.h"

@implementation Lundakarneval

+ (NSString *)timeLeftUntil:(NSString *)eventIdentifier {
    
    NSDictionary *events = [[self class] eventIdentifiers];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    
    NSDate *today = [NSDate date];
    NSDate *eventLaunch = [formatter dateFromString:events[eventIdentifier]];
    
    NSString *daysLeft = [[self class] daysBetweenDate:today andDate:eventLaunch];
    //int daysLeftNumeric = [daysLeft integerValue];
    
    //daysLeftNumeric = (daysLeftNumeric < 0) ? 0 : daysLeft; //after the launch.
    
    return daysLeft;
    
}

+ (NSDictionary *)eventIdentifiers {
    
#warning Se till så att datumen stämmer och lägg till efterhand.
    
    return @{
             
             @"ugglarp":@"2014-03-22 19:00",
             @"karnebal":@"2014-04-03 18:00",
             @"karneklubb":@"2014-03-28 18:00",
             @"tidningsdagen":@"2014-04-12 12:00",
             @"lundakarnevalen":@"2014-05-16 00:00",
             @"karnelan":@"2014-04-16 18:00",
             @"karnevöl_systemet":@"2014-04-01 09:00",
             @"frukost_picknick":@"2014-04-30 09:00",
             @"förkarneval":@"2014-05-11 19:00"
             
             };
    
}

+ (NSString *)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    if(fromDateTime && toDateTime) {
    
        NSDate *fromDate;
        NSDate *toDate;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        [calendar rangeOfUnit:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
                    startDate:&fromDate
                     interval:NULL
                      forDate:fromDateTime];
        
        [calendar rangeOfUnit:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
                    startDate:&toDate
                     interval:NULL
                      forDate:toDateTime];
        
        NSDateComponents *difference = [calendar components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                   fromDate:fromDate
                                                     toDate:toDate
                                                    options:0];
        
        NSInteger daysLeft = ([difference day] < 0) ? 0 : [difference day];
        NSInteger hoursLeft = ([difference hour] < 0) ? 0 : [difference hour];
        NSInteger minutesLeft = ([difference minute] < 0) ? 0 : [difference minute];
        
        NSString *timeLeft = [NSString stringWithFormat:@"%02d:%02d:%02d", daysLeft, hoursLeft, minutesLeft];
        
        return timeLeft;
        
    }
    
    return nil;
    
}

@end
