//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menu;

@end

@implementation MenuViewController

@synthesize menu;


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

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.menu = [NSArray arrayWithObjects:@"Start", @"Sektioner",@"Registrering",@"Meddelanden", nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    CGFloat nRed=43.0/255.0;
    CGFloat nBlue=40.0/255.0;
    CGFloat nGreen=42.0/255.0;
    
    self.tableView.backgroundColor = [[UIColor alloc]initWithRed:nRed green:nGreen blue:nBlue alpha:1];
    
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
    //return [self.menu count];
    return [self.menu count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row-1]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:20]];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (!(indexPath.row == 0)) {
        NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row-1]];
        
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];
    }
    
}

@end
