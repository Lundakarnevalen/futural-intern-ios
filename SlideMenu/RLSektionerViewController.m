//
//  RLSektionerViewController.m
//  Lundakarnevalens internapp
//
//  Created by Richard Luong on 2014-01-23.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "RLSektionerViewController.h"
#import "Sektioner.h"
#import "SektionerTableViewController.h"

#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface RLSektionerViewController ()

@property NSMutableArray *sektioner;

@end

@implementation RLSektionerViewController

- (IBAction)unwindSecondView:(UIStoryboardSegue *)segue { }

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistPath;

    plistPath = [[NSBundle mainBundle] pathForResource:@"sektioner" ofType:@"plist"];
    
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *tempSektioner = [temp objectForKey:@"sektioner"];
    self.sektioner = [[NSMutableArray alloc] init];
    
    for (id obj in tempSektioner) {
        Sektioner *sektion = [[Sektioner alloc] init];
        sektion.name = [obj objectForKey:@"name"];
        sektion.answer1 = [obj objectForKey:@"answer1"];
        sektion.answer2 = [obj objectForKey:@"answer2"];
        sektion.answer3 = [obj objectForKey:@"answer3"];
        sektion.answer4 = [obj objectForKey:@"answer4"];
        sektion.img = [obj objectForKey:@"img"];

        [self.sektioner addObject:sektion];
    }

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
    return [self.sektioner count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Sektioner *sektion = [self.sektioner objectAtIndex:indexPath.row];
    cell.textLabel.text = sektion.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    if (cell.textLabel.text.length > 14) {
        [cell.textLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:25]];
    } else {
        [cell.textLabel setFont:[UIFont fontWithName:@"Futura-Medium" size:30]];
    }
    
    
//    // Do some stuff
//    [cell addSubview:textLabel];
//    textLabel.text = [NSString stringWithFormat:@"%@", [self.answers objectAtIndex:indexPath.row-1]];
//    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    textLabel.numberOfLines = 0;
//    textLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
//    [textLabel setFont:[UIFont systemFontOfSize:14]];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetailedSegue"]){
        SektionerTableViewController *controller = (SektionerTableViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        controller.sektion = [self.sektioner objectAtIndex:indexPath.row];
        NSLog(@"%@", [self.sektioner objectAtIndex:indexPath.row]);
    }
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
