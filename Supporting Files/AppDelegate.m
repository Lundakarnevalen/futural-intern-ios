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
    
    return YES;
}

-(void)registerForPushNotifications {
    NSLog(@"Registering for push notifications...");
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSString *title = [userInfo[@"aps"] objectForKey:@"alert"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:@"Du har fått ett nytt meddelande"  delegate:self
                                              cancelButtonTitle:@"Avbryt"
                                              otherButtonTitles:@"Öppna", nil];
    [alertView show];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"Went to Background");
    // Only monitor significant changes
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    
    NSDate *today = [NSDate date];
    NSDate *tidningsdagen = [formatter dateFromString:@"2014-04-12 23:59"];
    
    if ([today compare:tidningsdagen] == NSOrderedAscending) {
        [self.locationManager stopMonitoringSignificantLocationChanges];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSLog(@"Did become active.");
    // Start location services
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    
    NSDate *today = [NSDate date];
    NSDate *tidningsdagen = [formatter dateFromString:@"2014-04-12 23:59"];
    
    if ([today compare:tidningsdagen] == NSOrderedAscending) {
        
        if (!_locationManager) {
            
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self; //fix
            
        }
        
    }
}

-(void)startLocationManager {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    
    NSDate *today = [NSDate date];
    NSDate *tidningsdagen = [formatter dateFromString:@"2014-04-12 23:59"];
    
    if ([today compare:tidningsdagen] == NSOrderedAscending) {
        NSLog(@"Innan tidningsdagen");
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager stopMonitoringSignificantLocationChanges];
            [self.locationManager startMonitoringSignificantLocationChanges];
        }
    }
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
    
    if ([self isSignedIn]) {
        
        NSLog(@"Nu vill jag sända till serven.");
        [self updateLocation:location isInBackground:isInBackground];
        
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
