//
//  RLSektionerDetailedViewController.m
//  Lundakarnevalens internapp
//
//  Created by Richard Luong on 2014-01-28.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "RLSektionerDetailedViewController.h"
//#import "RLSektionerViewController.h"
#import "RLSektioner.h"

@interface RLSektionerDetailedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UITextView *textInfo;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;


@end

@implementation RLSektionerDetailedViewController

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
    [_scroller setScrollEnabled:YES];
    _scroller.backgroundColor = [UIColor clearColor];
    
    [_scroller setContentSize:CGSizeMake(320, 920)];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _Title.text = self.sektion.name;
    _textInfo.text = self.sektion.answer1;

    self.navigationItem.title = self.sektion.name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
