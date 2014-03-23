//
//  MapListTableViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MapViewController.h"
#import "MapListTableViewController.h"
#import "MapCity.h"

#define TAG_LETTERLABEL 1004
#define TAG_CITYLABEL 1003
#define TAG_NUMBEROFKARNEVALISTERLABEL 1005

@interface MapListTableViewController ()

@property (strong, nonatomic) NSArray *cities;

@end

@implementation MapListTableViewController

-(NSArray *)cities {
    if(!_cities) _cities = [[NSArray alloc] init];
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
    
    return _cities;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.cities count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    
    MapCity *city = [self.cities objectAtIndex:indexPath.row];
    
    // Display recipe in the table cell
    UILabel *cityLabel = (UILabel *)[cell viewWithTag:TAG_CITYLABEL];
    cityLabel.text = city.name;
    
    UILabel *numberOfKarnevalisterLabel = (UILabel *)[cell viewWithTag:TAG_NUMBEROFKARNEVALISTERLABEL];
    numberOfKarnevalisterLabel.text = [NSString stringWithFormat:@"%d karnevalister", (int) city.numberOfKarnevalister];
    
    UILabel *letterLabel = (UILabel *)[cell viewWithTag:TAG_LETTERLABEL];
    letterLabel.text = [city.name substringWithRange:NSMakeRange(0, 1)];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

@end
