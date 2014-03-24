//
//  AppDelegate.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"

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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Went to Background");
    // Only monitor significant changes
    if ([self.api isSignedIn]) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Start location services
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Only report to location manager if the user has traveled 1000 meters
    self.locationManager.distanceFilter = 10.0f;
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
    if ([self.api isSignedIn]) {
        [self.locationManager startUpdatingLocation];
    }
    
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
        NSLog(@"Sending to location lat: %f long: %f", location.coordinate.latitude, location.coordinate.longitude);
        //[self.locationManager sendBackgroundLocationToServer:[locations lastObject]];
    } else {
        // If we're not in the background wait till the GPS is accurate to send it to the server
        if ([[locations lastObject] horizontalAccuracy] < 100.0f) {
            NSLog(@"Sending to location lat: %f long: %f", location.coordinate.latitude, location.coordinate.longitude);
            //[self.locationManager sendDataToServer:[locations lastObject]];
        }
    }
    
}

@end
