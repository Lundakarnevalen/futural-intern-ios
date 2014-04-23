//
//  SongbookTableViewController.m
//  Karnevalisten
//
//  Created by Lisa Ellerstedt on 2014-03-30.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "SongbookTableViewController.h"
#import "Song.h"
#import "ECSlidingViewController.h"

#import "DetailedSongViewController.h"

#define TAG_HEADER 1001
#define TAG_ISWINNER 1002

#define TAG_PAGENUMBER 2001
#define TAG_SECTIONLABEL 3001
#define TAG_SECTIONIMAGE 3002

@interface SongbookTableViewController ()

@property (nonatomic) NSMutableArray *songs;
@property (nonatomic) NSMutableArray *songsSections;

@end

@implementation SongbookTableViewController

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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"songs" ofType:@"plist"];
    
    NSArray *tempSongs = [[NSDictionary dictionaryWithContentsOfFile:plistPath] objectForKey:@"songs"];
    self.songs = [[NSMutableArray alloc] init];
    self.songsSections = [[NSMutableArray alloc] init];
    int i = -1;
    for (NSDictionary *dict in tempSongs) {
        if (![self.songsSections containsObject:dict[@"category"]]) {
            i++;
            [self.songs addObject:[[NSMutableArray alloc] init]];
            [self.songsSections addObject:dict[@"category"]];
        }
        
        Song *song = [[Song alloc] initWithDictionary:dict];
        
        [[self.songs objectAtIndex:i] addObject:song];
    }
    
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
    return [self.songsSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.songs objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Song *song = [self songAtIndexPath:indexPath];
    NSString *cellIdentifier = @"songCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    UILabel * headerLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_HEADER];
    UILabel * pageNumberLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_PAGENUMBER];
    UIImageView *image = (UIImageView *)[[cell contentView] viewWithTag:TAG_ISWINNER];
    image.hidden = !song.isWinner;
    
    [headerLabel setText:song.name];
    [pageNumberLabel setText:[NSString stringWithFormat:@"%@", song.pageNumber]];
    
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"sectionHeader" owner:self options:nil];
    UIView *nibView = [nibObjects objectAtIndex:0];
    UILabel * pageNumberLabel = (UILabel *)[nibView viewWithTag:TAG_SECTIONLABEL];
    NSString *category = [[[self.songs objectAtIndex:section] objectAtIndex:0] category];
    pageNumberLabel.text = category;
    UIImageView *image = (UIImageView *)[nibView viewWithTag:TAG_SECTIONIMAGE];
    image.image = [Song imageForCategoryWithName:category];
    return nibView;
}

#pragma mark - table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell at section: %d row: %d", indexPath.section, indexPath.row);
}
    

-(Song *)songAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.songs objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailedSongViewSegue"]) {
        DetailedSongViewController *viewController = (DetailedSongViewController *)segue.destinationViewController;
        viewController.song = [self songAtIndexPath:[self.tableView indexPathForCell:sender]];
    }
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
