//
//  RLSektionerViewController.m
//  Lundakarnevalens internapp
//
//  Created by Richard Luong on 2014-01-23.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "RLSektionerViewController.h"
#import "RLSektioner.h"
#import "SektionerTableViewController.h"

#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface RLSektionerViewController ()

@property NSMutableArray *sektioner;

@end

@implementation RLSektionerViewController

- (IBAction)unwindSecondView:(UIStoryboardSegue *)segue { }

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
    
    NSString *plistPath;

    plistPath = plistPath = [[NSBundle mainBundle] pathForResource:@"sektioner" ofType:@"plist"];
    
    NSDictionary *temp = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *tempSektioner = [temp objectForKey:@"sektioner"];
    self.sektioner = [[NSMutableArray alloc] init];
    
    for (id obj in tempSektioner) {
        RLSektioner *sektion = [[RLSektioner alloc] init];
        sektion.name = [obj objectForKey:@"name"];
        sektion.answer1 = [obj objectForKey:@"answer1"];
        sektion.answer2 = [obj objectForKey:@"answer2"];
        sektion.answer3 = [obj objectForKey:@"answer3"];
        sektion.answer4 = [obj objectForKey:@"answer4"];

        [self.sektioner addObject:sektion];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.sektioner count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    RLSektioner *sektion = [self.sektioner objectAtIndex:indexPath.row];
    cell.textLabel.text = sektion.name;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //RLSektioner *sektion = [self.sektioner objectAtIndex:indexPath.row];
    NSLog(@"%d", indexPath.row);
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
