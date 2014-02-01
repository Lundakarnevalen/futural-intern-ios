//
//  SektionerTableViewController.m
//  Karnevalist2014
//
//  Created by Richard Luong on 2014-01-31.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "SektionerTableViewController.h"

@interface SektionerTableViewController ()

@property NSMutableArray *answers, *questions;
@property NSString *question1, *question2, *question3, *question4;

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
    
    self.navigationItem.title = self.sektion.name;
    
    self.answers = [[NSMutableArray arrayWithObjects: self.sektion.answer1, self.sektion.answer2, self.sektion.answer3, self.sektion.answer4, nil] init];
    
    self.question1 = [NSString stringWithFormat: @"Vad ska %@ göra? Vad är den övergripande “uppgiften”?", self.sektion.name];
    self.question2 = [NSString stringWithFormat: @"Vad finns det för olika saker att göra i %@?", self.sektion.name];
    self.question3 = @"Hur många kommer ni vara i sektionen (ungefär)?";
    self.question4 = [NSString stringWithFormat: @"Vad är det bästa med %@? Vad är speciellt?", self.sektion.name];
    
    self.questions = [[NSMutableArray arrayWithObjects: self.question1, self.question2, self.question3, self.question4, nil] init];
    
//    NSLog(@"%@", self.question1);
//    NSLog(@"%@", self.question2);
//    NSLog(@"%@", self.question3);
//    NSLog(@"%@", self.question4);
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
    return [self.answers count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Configure the cell...
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"PrototypeCellID1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 40)] init];
        // Do some stuff
        [cell addSubview:label];
        label.text = self.sektion.name;
        if (label.text.length > 14) {
            [label setFont:[UIFont fontWithName:@"Futura-Medium" size:28]];
        } else {
            [label setFont:[UIFont fontWithName:@"Futura-Medium" size:35]];
        }
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,100,300,134)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageView];
        
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:@"happy_robot.png"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        static NSString *CellIdentifier = @"PrototypeCellID2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 50)] init];
        // Do some stuff
        [cell.contentView addSubview:label];
        label.text = [self.questions objectAtIndex:indexPath.row-1];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        [label setFont:[UIFont boldSystemFontOfSize:17]];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label setBackgroundColor:[UIColor clearColor]];
        
        NSString *ans = [NSString stringWithFormat:@"%@", [self.answers objectAtIndex:indexPath.row-1]];
        UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20, 80, 280, [self heightForTextLabel:ans])] init];
        NSLog(@"Height label at %d: %d, cell %d", indexPath.row, (NSInteger)[self heightForTextLabel:ans], (NSInteger)[self heightForTextLabel:ans]+60);
        
        // Do some stuff
        
        [cell.contentView addSubview:textLabel];
        textLabel.text = [NSString stringWithFormat:@"%@", [self.answers objectAtIndex:indexPath.row-1]];
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [textLabel setBackgroundColor:[UIColor clearColor]];
        return cell;
        
    }
}

- (CGFloat)heightForTextLabel: (NSString *)text {
    NSInteger length = [text length];
    NSInteger padding = 20;
    return length / 40 * 14 + padding;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%d", indexPath.row);
//    return 300;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250;
    }
    
    NSString *theText = [self.answers objectAtIndex:indexPath.row-1];
    
//    if ([theText respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
//        CGRect rect = [theText boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX) options:0 attributes:nil context:nil];
//        return rect.size.height;
//    } else {
//        CGSize size = [theText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(self.view.bounds.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//        return size.height;
//    }
    
    NSInteger length = [theText length];
    NSInteger padding = 60;
    return length / 40 * 14 + padding + 60;
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
