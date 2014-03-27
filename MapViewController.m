//
//  MapViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-20.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MapViewController.h"
#import "Colors.h"
#import "Cluster.h"

#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#include <UIKit/UIKit.h>

#import "FuturalAPI.h"

#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberOfKarnevalistLabel;
@property (strong, nonatomic) NSArray *clusters;
@property (strong, nonatomic) NSMutableArray *cityCircles;

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *kartaImageView;

@property (nonatomic) FuturalAPI *api;
@property (nonatomic) NSMutableData *dataQueue;

@end

#define yScale 235/12.997;
#define xScale 60/55.5505;

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
    
    [self initClusters];
    
    //[self loadClusters];
    
   // {"sucess":true,"clusters":"[{\"id\":1,\"lat\":55.7104,\"lng\":13.2083,\"quantity\":40},{\"id\":11,\"lat\":56.2568,\"lng\":12.5988,\"quantity\":50},{\"id\":21,\"lat\":55.6051,\"lng\":13.0027,\"quantity\":10},{\"id\":31,\"lat\":55.5505,\"lng\":12.997,\"quantity\":10}]"}
//    
//    MapCity *city1 = [[MapCity alloc] init];
//    city1.name = @"Lund";
//    city1.numberOfKarnevalister = 1000;
//    city1.location = CGPointMake(123.5, 291.0);
//    
//    MapCity *city2 = [[MapCity alloc] init];
//    city2.name = @"Malmö";
//    city2.numberOfKarnevalister = 500;
//    city2.location = CGPointMake(94.5, 335.0);
//    
//    MapCity *city3 = [[MapCity alloc] init];
//    city3.name = @"Kristianstad";
//    city3.numberOfKarnevalister = 100;
//    city3.location = CGPointMake(285.0, 263.5);
//    _cities = @[city1, city2, city3];
//    
//    [self loadCities];
    
    //[self.api fetchLocations];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - cluster

-(void)initClusters {
//    Cluster *c1 = [[Cluster alloc] initWithLat:55.7104 lng:13.2083 quantity:40 identification:1];
//    Cluster *c2 = [[Cluster alloc] initWithLat:56.2568 lng:12.5988 quantity:50 identification:11];
//    Cluster *c3 = [[Cluster alloc] initWithLat:55.6051 lng:13.0027 quantity:10 identification:21];
//    Cluster *c4 = [[Cluster alloc] initWithLat:55.5505 lng:12.997 quantity:10 identification:31];
//    self.clusters = @[c1, c2, c3, c4];
}

/*
-(void)loadClusters {
    for (Cluster *cluster in self.clusters) {
        CGFloat radius = cluster.quantity / 20;
        if (radius<10) radius = 1.0;
        NSLog(@"%f", radius);
        CGFloat x = 60.0;
        CGFloat y = 60.0;
        
        //CGFloat x =  (int) ((280/360.0) * (180 + cluster.lng));
        //CGFloat y =  (int) ((300/180.0) * (90 - cluster.lat));
        
        //CGFloat x = cluster.lat * xScale;
        //CGFloat y = cluster.lng * yScale;
        CGPoint point = CGPointMake(x, y);
        [self drawCircleAtPoint:point radius:radius];
    }
}

-(void)drawCircleAtPoint:(CGPoint)point radius:(CGFloat)radius {
    UIView *circle = [[UIView alloc] init];
    circle.frame = CGRectMake(point.x - radius, point.y - radius, radius*2, radius*2);
    circle.backgroundColor = [Colors redColorWithAlpha:0.45];
    circle.layer.cornerRadius = circle.bounds.size.height /2;

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tappedOnCity:)];
    //[circle addGestureRecognizer:singleFingerTap];
    [self.cityCircles addObject:circle];
    [self.kartaImageView addSubview:circle];
}
- (IBAction)imageTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"x: %f y: %f", [sender locationInView:sender.view].x, [sender locationInView:sender.view].y);
}
*/
//-(void)getLocation {
//    if ([CLLocationManager locationServicesEnabled]) {
//        if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusAuthorized) {
//            //self.statusLabel.hidden = YES;
//            self.statusLabel.hidden = NO;
//            self.statusLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"locTimestamp"];
//        } else {
//            self.statusLabel.hidden = NO;
//            self.statusLabel.text = @"Not authorized.";
//        }
//    } else {
//        self.statusLabel.hidden = NO;
//        self.statusLabel.text = @"Location services are not enabled.";
//    }
//}
//
//-(void)loadCities {
//    for (MapCity *city in self.cities) {
//        CGFloat radius = (int) city.numberOfKarnevalister / 25.0;
//        if (radius<10) radius = 10.0;
//        NSLog(@"%@ och antal %f", city.name, radius);
//        [self drawCircle:city.location radius:radius];
//    }
//}
//
//-(void)setTextLabelsWhenCityIsChoosed:(MapCity *)city{
//    self.numberOfKarnevalistLabel.text = [NSString stringWithFormat:@"%d", (int) city.numberOfKarnevalister];
//     self.cityNameLabel.text = [NSString stringWithFormat:@"%@", city.name];
//}
//
//-(void)drawCircle:(CGPoint)point radius:(CGFloat)radius {
//    UIView *circle = [[UIView alloc] init];
//    circle.frame = CGRectMake(point.x - radius, point.y - radius, radius*2, radius*2);
//    circle.backgroundColor = [Colors redColorWithAlpha:0.45];
//    circle.layer.cornerRadius = circle.bounds.size.height /2;
//    
//    UITapGestureRecognizer *singleFingerTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self
//                                            action:@selector(tappedOnCity:)];
//    [circle addGestureRecognizer:singleFingerTap];
//    [self.cityCircles addObject:circle];
//    [self.view addSubview:circle];
//}
//
//-(NSMutableArray *)cityCircles {
//    if (!_cityCircles) _cityCircles = [[NSMutableArray alloc] init];
//    return _cityCircles;
//}
//
//-(IBAction)tappedOnCity:(UITapGestureRecognizer *)sender {
//    sender.view.backgroundColor = [Colors redColorWithAlpha:1];
//    NSUInteger index = [self.cityCircles indexOfObject:sender.view];
//    
//    for (int i = 0; i < [self.cityCircles count]; i++) {
//        if (i != index) {
//            [[self.cityCircles objectAtIndex:i] setBackgroundColor:[Colors redColorWithAlpha:0.45]];
//        }
//    }
//    
//    MapCity *city = [self.cities objectAtIndex:index];
//    
//    NSLog(@"Du klickade på en stad med index %d. Alltså %@ med %d karnevalister.", (int) index, city.name, (int) city.numberOfKarnevalister);
//    
//    [self setTextLabelsWhenCityIsChoosed:city];
//}

#pragma mark -NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.dataQueue appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //[self.activitySpinner stopAnimating];
    
    id parsedData = [[self.api class] parseJSONData:self.dataQueue];
    self.dataQueue = nil;
    
    if(parsedData) {
        
        parsedData = (NSDictionary *)parsedData;
        
        //if(parsedData[@"notifications"]) { //check if it's the push messages that is being requested.
            
            //for(NSDictionary *notification in parsedData[@"notifications"]) {
                
                //Message *message = [[Message alloc] initWithDictionary:notification];
                //[self.messages addObject:message];
                
            //}
            
            //[self.messagesTable reloadData];
            
        //}
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
    //[self.activitySpinner stopAnimating];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
}

- (NSMutableData *)dataQueue {
    
    if(!_dataQueue) {
        
        _dataQueue = [[NSMutableData alloc] init];
        
    }
    
    return _dataQueue;
    
}

- (FuturalAPI *)api {
    
    if(!_api) {
        
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
        
    }
    
    return _api;
    
}

#pragma mark - slidingview controller
- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
