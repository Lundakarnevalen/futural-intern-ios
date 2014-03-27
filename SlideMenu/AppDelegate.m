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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([self.window respondsToSelector:@selector(setTintColor:)]) { //status bar tint.
        
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
    
    NSString *str = [NSString stringWithFormat:@"%@", deviceToken];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str substringWithRange:NSMakeRange(1, [str length]-2)];
    NSLog(@"%@", str);
    [self.api sendAppleToken:str];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@", str);
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"Went to Background");
    // Only monitor significant changes
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
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

#pragma mark - location methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
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
        
        if ([self isSignedIn]) {
            
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
    
    return [self.api isSignedIn];
    
}

-(void)updateLocation:(CLLocation *)location isInBackground:(bool)isInBackground {
    
    if(isInBackground) {
        
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            
        }];
        
    }
    
    /*[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:location.coordinate.latitude] forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:location.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:location.timestamp forKey:@"locTimestamp"];*/
    
    [self.api updateLocation:location];
    
    if(isInBackground) {
        
        if(self.bgTask != UIBackgroundTaskInvalid) {
            
            [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
            self.bgTask = UIBackgroundTaskInvalid;
            
        }
        
    }
}

-(FuturalAPI *)api {
    
    if (!_api) _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
    
    return _api;
    
}

- (NSMutableData *)dataQueue {
    
    if(!_dataQueue) {
        
        _dataQueue = [[NSMutableData alloc] init];
        
    }
    
    return _dataQueue;
    
}

#pragma mark -NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.dataQueue appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    id parsedData = [[self.api class] parseJSONData:self.dataQueue];
    self.dataQueue = nil;
    
    if(parsedData) {
        
        parsedData = (NSDictionary *)parsedData;
        
        NSString *stringIdentifier = [FuturalAPI stringIdentifierFromUrlConnection:connection];
        NSString *method = [FuturalAPI methodFromURLConnection:connection];
        
        if([stringIdentifier isEqualToString:@"maps"] && [method isEqualToString:@"POST"]) { //created cluster.
            
            if(parsedData[@"cluster_id"]) {
                
                self.api.karnevalist.cluster.identifier = parsedData[@"cluster_id"];
                
            }
            
        }
        
        if([stringIdentifier isEqualToString:@"maps"] && [method isEqualToString:@"PUT"]) { //updated cluster.
            
            if(parsedData[@"cluster_id"]) {
                
                self.api.karnevalist.cluster.identifier = parsedData[@"cluster_id"];
                
            }
            
            NSLog(@"successfully updated the cluster-id %@. response: \n%@", self.api.karnevalist.cluster.identifier, parsedData);
            
        }
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
   // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
   // NSLog(@"%@", [httpResponse allHeaderFields]);
    
}


@end
