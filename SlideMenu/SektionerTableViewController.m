//
//  SektionerTableViewController.m
//  Karnevalist2014
//
//  Created by Richard Luong on 2014-01-31.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "SektionerTableViewController.h"

@interface SektionerTableViewController ()

@property NSArray *answers;

@end

@implementation SektionerTableViewController

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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.answers = [[NSArray arrayWithObjects:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc ornare quam nisi, a convallis lacus egestas a. Duis id accumsan neque. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nunc dapibus neque tortor, a congue turpis congue ac. Integer condimentum, dui viverra consequat faucibus, justo nulla aliquet dui, hendrerit scelerisque enim sem quis leo. Fusce porta eu metus in porttitor. Aliquam eget tincidunt diam. Aenean volutpat enim at volutpat venenatis. Etiam eleifend ut sapien sit amet vestibulum. In adipiscing velit ac felis ultricies consequat.", @"Nulla nisi odio, viverra sed auctor nec, dignissim nec nibh. Integer blandit risus sit amet mi suscipit condimentum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In ullamcorper dignissim eros in dictum. Suspendisse erat libero, laoreet at lacus dictum, tempus lobortis urna. Praesent vel diam ac sapien facilisis consectetur. Morbi blandit bibendum mi, in feugiat leo viverra nec. Maecenas odio purus, varius ac diam et, pharetra sollicitudin enim.",@"Aliquam dolor lacus, scelerisque id semper id, sagittis sed metus. Nam eu ipsum at justo blandit blandit. Fusce sollicitudin orci nibh, at malesuada erat posuere sit amet. Cras eget justo tincidunt, sollicitudin elit at, volutpat nulla. Etiam in risus non ipsum tincidunt accumsan. Nullam id libero sit amet metus tempus cursus non sit amet ligula. Vivamus luctus fringilla nulla ut adipiscing. Duis porttitor nunc et fermentum interdum. Morbi tortor elit, interdum elementum ipsum ac, auctor laoreet orci. Sed vehicula egestas pretium. Mauris tincidunt dolor vitae tellus venenatis facilisis.",@"Pellentesque et tristique dui. Proin vel dapibus nisl, eget lacinia sapien. Nullam a nisi eget lectus tempor consectetur euismod sed tellus. Cras imperdiet turpis ante, vitae sodales erat porttitor vel. Nam vel dapibus arcu. Aenean sed justo vulputate, viverra nisi eu, porttitor sem. Nulla iaculis, tellus vel rutrum euismod, diam diam ornare nisi, ac laoreet metus turpis eget massa.", nil] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.answers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.answers objectAtIndex:indexPath.row]];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%d", indexPath.row);
//    return 300;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *theText=[self.answers objectAtIndex:indexPath.row];
    NSInteger length = [theText length];
    return length-110;
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
