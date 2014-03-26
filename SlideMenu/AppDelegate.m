//
//  AppDelegate.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "Identification.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([self.window respondsToSelector:@selector(setTintColor:)]) {
        [self.window setTintColor:[UIColor whiteColor]];
    } else {
        UIBarButtonItem *buttonItem = [UIBarButtonItem appearance];
        [buttonItem setTintColor:[UIColor clearColor]];
        [buttonItem setBackgroundImage:[UIImage imageNamed:@"blank.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str substringWithRange:NSMakeRange(1, [str length]-2)];
    NSLog(@"%@", str);
    [self.api sendAppleToken:str];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Went to Background");
    // Only monitor significant changes
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Did become active.");
    // Start location services
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
#warning ändra detta innan uppladdning!
    
    // Only report to location manager if the user has traveled 1000 meters
    self.locationManager.distanceFilter = 1000.0f;
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - location methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    // Check if running in background or not
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        isInBackground = YES;
    }
    CLLocation *location = [locations lastObject];
    NSLog(@"Location Manager isInBackground: %hhd", isInBackground);
    
    if (isInBackground) {
        // If we're running in the background, run sendBackgroundLocationToServer
        NSLog(@"Fetched new location lat: %f long: %f", location.coordinate.latitude, location.coordinate.longitude);
        NSLog(@"isSignedIn: %d", [self isSignedIn]);
        if ([self isSignedIn] == YES) {
            NSLog(@"Nu vill jag sända till serven.");
            [self updateLocation:location isInBackground:isInBackground];
        }
    } else {
        // If we're not in the background wait till the GPS is accurate to send it to the server
        if ([[locations lastObject] horizontalAccuracy] < 100.0f) {
            NSLog(@"Fetched new location lat: %f long: %f", location.coordinate.latitude, location.coordinate.longitude);
            NSLog(@"isSignedIn: %d", [self isSignedIn]);
            if ([self isSignedIn] == YES) {
                NSLog(@"Nu vill jag sända till serven.");
                [self updateLocation:location isInBackground:isInBackground];
            }
        }
    }
}

-(bool)isSignedIn {
    
    return ([[NSUserDefaults standardUserDefaults] stringForKey:[Identification.class tokenIdentifier]] != nil);
}

-(void)updateLocation:(CLLocation *)location isInBackground:(bool)isInBackground {
    if (isInBackground) {
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        }];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:location.timestamp forKey:@"locTimestamp"];
    [self.api updateLocation:location];
    
    if (isInBackground) {
        if (self.bgTask != UIBackgroundTaskInvalid)
        {
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            self.bgTask = UIBackgroundTaskInvalid;
        }
    }
}

-(FuturalAPI *)api {
    if (!_api) _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
    return _api;
}

#pragma mark -NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.dataQueue appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
}


@end
