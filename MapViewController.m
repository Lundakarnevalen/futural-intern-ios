//
//  MapViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-20.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MapViewController.h"
#import "Colors.h"
#import "MapCity.h"

#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#include <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberOfKarnevalistLabel;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSMutableArray *cityCircles;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startLocation;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitutdeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MapCity *city1 = [[MapCity alloc] init];
    city1.name = @"Lund";
    city1.numberOfKarnevalister = 1000;
    city1.location = CGPointMake(123.5, 291.0);
    
    MapCity *city2 = [[MapCity alloc] init];
    city2.name = @"Malmö";
    city2.numberOfKarnevalister = 500;
    city2.location = CGPointMake(94.5, 335.0);
    
    MapCity *city3 = [[MapCity alloc] init];
    city3.name = @"Kristianstad";
    city3.numberOfKarnevalister = 100;
    city3.location = CGPointMake(285.0, 263.5);
    _cities = @[city1, city2, city3];
    
    [self loadCities];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLocation) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getLocation];
}

-(void)getLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorized) {
            self.statusLabel.hidden = YES;
            if (!self.locationManager) self.locationManager = [[CLLocationManager alloc] init];
            
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            self.locationManager.distanceFilter = 100.0;
            
            [self.locationManager startUpdatingLocation];
            
            [NSTimer scheduledTimerWithTimeInterval:100.0 target:self selector:@selector(startLocationService) userInfo:nil repeats:YES];
        } else {
            self.statusLabel.hidden = NO;
            self.statusLabel.text = @"Not authorized.";
        }
    } else {
        self.statusLabel.hidden = NO;
        self.statusLabel.text = @"Location services are not enabled.";
    }
}

-(void)startLocationService {
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"New location Lat: %f Long: %f", location.coordinate.latitude, location.coordinate.longitude);
    self.latitudeLabel.text = [NSString stringWithFormat:@"Lat: %f", location.coordinate.latitude];
    self.longitutdeLabel.text = [NSString stringWithFormat:@"Long: %f", location.coordinate.longitude];
    [self.locationManager stopUpdatingLocation];
}

-(void)loadCities {
    for (MapCity *city in self.cities) {
        CGFloat radius = (int) city.numberOfKarnevalister / 25.0;
        if (radius<10) radius = 10.0;
        NSLog(@"%@ och antal %f", city.name, radius);
        [self drawCircle:city.location radius:radius];
    }
}

-(void)setTextLabelsWhenCityIsChoosed:(MapCity *)city{
    self.numberOfKarnevalistLabel.text = [NSString stringWithFormat:@"%d", (int) city.numberOfKarnevalister];
     self.cityNameLabel.text = [NSString stringWithFormat:@"%@", city.name];
}

-(void)drawCircle:(CGPoint)point radius:(CGFloat)radius {
    UIView *circle = [[UIView alloc] init];
    circle.frame = CGRectMake(point.x - radius, point.y - radius, radius*2, radius*2);
    circle.backgroundColor = [Colors redColorWithAlpha:0.45];
    circle.layer.cornerRadius = circle.bounds.size.height /2;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tappedOnCity:)];
    [circle addGestureRecognizer:singleFingerTap];
    [self.cityCircles addObject:circle];
    [self.view addSubview:circle];
}

-(NSMutableArray *)cityCircles {
    if (!_cityCircles) _cityCircles = [[NSMutableArray alloc] init];
    return _cityCircles;
}

-(IBAction)tappedOnCity:(UITapGestureRecognizer *)sender {
    sender.view.backgroundColor = [Colors redColorWithAlpha:1];
    NSUInteger index = [self.cityCircles indexOfObject:sender.view];
    
    for (int i = 0; i < [self.cityCircles count]; i++) {
        if (i != index) {
            [[self.cityCircles objectAtIndex:i] setBackgroundColor:[Colors redColorWithAlpha:0.45]];
        }
    }
    
    MapCity *city = [self.cities objectAtIndex:index];
    
    NSLog(@"Du klickade på en stad med index %d. Alltså %@ med %d karnevalister.", (int) index, city.name, (int) city.numberOfKarnevalister);
    
    [self setTextLabelsWhenCityIsChoosed:city];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
