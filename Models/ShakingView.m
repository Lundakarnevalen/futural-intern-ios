//
//  ShakingView.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "ShakingView.h"

NSString *const DeviceDidShake             = @"DeviceDidShake";

@implementation ShakingView

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
        // Put in code here to handle shake
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:DeviceDidShake object:self]];
        NSLog(@"Shakey shakey.");
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

@end
