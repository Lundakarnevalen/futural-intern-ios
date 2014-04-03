//
//  MenuTableViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "Sektioner.h"

#define TAG_MENULABEL 1006

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menu;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (nonatomic) NSMutableDictionary *viewCache; //private, kind of.

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = NO; //if set to YES (default) the subviews won't respond to the statusbar-tap.
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm"];
    
    NSDate *today = [NSDate date];
    NSDate *tidningsdagen = [formatter dateFromString:@"2014-04-12 23:59"];
    
    if ([today compare:tidningsdagen] == NSOrderedDescending) {
        self.menu = [NSArray arrayWithObjects: @"Start", @"Inkorg", nil];
    } else {
        self.menu = [NSArray arrayWithObjects: @"Start", @"Inkorg", @"Karta", nil];
    }
    
    /*cache the first view as well*/
    [self cacheStoryboard:self.storyboard withIdentifier:[self.menu firstObject]];
    [self cacheViewController:self.slidingViewController.topViewController withIdentifier:[NSString stringWithFormat:@"vc_%@", [self.menu firstObject]]];
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    NSDictionary *karnevalist = [[NSUserDefaults standardUserDefaults] valueForKey:@"karnevalist"];
    self.nameLabel.text = [[karnevalist[@"fornamn"] stringByAppendingString:[@" " stringByAppendingString:karnevalist[@"efternamn"]]] uppercaseString];
    
    Sektioner *sektion = [[Sektioner sektioner] objectForKey:[NSString stringWithFormat:@"%d", [karnevalist[@"tilldelad_sektion"] integerValue]]];
    self.profileImageView.image = [UIImage imageNamed:sektion.img];
    
}

-(NSArray *)menu {
    if (!_menu) _menu = [[NSArray alloc] init];
    return _menu;
}

- (NSMutableDictionary *)viewCache {
    
    if(!_viewCache) {
        
        _viewCache = [[NSMutableDictionary alloc] init];
        
    }
    
    return _viewCache;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    UILabel *menuLabel = (UILabel *)[cell viewWithTag:TAG_MENULABEL];
    menuLabel.text = [[self.menu objectAtIndex:indexPath.row] uppercaseString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menu objectAtIndex:indexPath.row]];
    NSString *viewControllerIdentifier = [NSString stringWithFormat:@"vc_%@", identifier]; //to keep track of it in the dictionary.
    
    UIStoryboard *storyboard = self.viewCache[identifier]; //nil if not instantiated.
    UIViewController *newTopViewController = self.viewCache[viewControllerIdentifier]; //-----||------
    
    if(!storyboard) {
    
        storyboard = [UIStoryboard storyboardWithName:identifier bundle:nil]; //store the storyboard in the dictionary.
        [self cacheStoryboard:storyboard withIdentifier:identifier];
        
    }
    
    if(!newTopViewController) {
        
        newTopViewController = [storyboard instantiateInitialViewController]; //-----||-----
        [self cacheViewController:newTopViewController withIdentifier:viewControllerIdentifier];
        
    }
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
    
}

#pragma mark - Cache

- (void)cacheStoryboard:(UIStoryboard *)storyboard withIdentifier:(NSString *)identifier {
    
    self.viewCache[identifier] = storyboard;
    
}

- (void)cacheViewController:(UIViewController *)viewController withIdentifier:(NSString *)identifier {
    
    self.viewCache[identifier] = viewController;
    
}

- (void)destroyCache { //in case of memory warnings.
    
    [self.viewCache removeAllObjects];
    self.viewCache = nil;
    
}

@end