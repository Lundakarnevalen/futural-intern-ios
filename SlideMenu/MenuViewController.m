//
//  MenuTableViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-25.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"

#define TAG_MENULABEL 1006

@interface MenuViewController ()

@property (strong, nonatomic) NSArray *menu;

@property (nonatomic) NSMutableDictionary *viewCache; //private, kind of.

@end

@implementation MenuViewController

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
    
    self.tableView.scrollsToTop = NO; //if set to YES (default) the subviews won't respond to the statusbar-tap.
    self.menu = [NSArray arrayWithObjects: @"Start", @"Inkorg", @"Karta" , nil];
    
    [self.slidingViewController setAnchorRightRevealAmount:200.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
