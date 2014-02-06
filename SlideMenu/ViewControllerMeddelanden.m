//
//  ViewControllerMeddelanden.m
//  Karnevalist2014
//
//  Created by Richard Luong on 2014-01-31.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "ViewControllerMeddelanden.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface ViewControllerMeddelanden ()

@property UIActivityIndicatorView *spinner;

@end

@implementation ViewControllerMeddelanden

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    NSURL *myWeview = [NSURL URLWithString:@"http://www.karnevalist.se/notifications"];
    NSURLRequest *myrequest = [NSURLRequest requestWithURL:myWeview];
    [myWebView loadRequest:myrequest];
    
    //spinner
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    self.spinner.frame = CGRectMake(self.spinner.frame.origin.x-10, self.spinner.frame.origin.y-10, self.spinner.frame.size.width+20, self.spinner.frame.size.height+20);
    [self.spinner.layer setCornerRadius:3.0f];
    [self.spinner setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    [self.view addSubview:self.spinner];
    
    myWebView.delegate = self;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    [self.spinner startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
    
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


@end
