//
//  AppDelegate.h
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FuturalAPI.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic) FuturalAPI *api;
@property (nonatomic) NSMutableData *dataQueue;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;

-(void)startLocationManager;
-(void)registerForPushNotifications;


@end
