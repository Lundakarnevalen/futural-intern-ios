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
    
    //Swipe höger
	UISwipeGestureRecognizer  *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handlerightSwipe:)];
    swipeRight.numberOfTouchesRequired = 1;//give required num of touches here ..
    swipeRight.delegate = (id)self;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // add loading image
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,100,300,134)];
    imageView.image = [UIImage imageNamed:@"ajax-loader.gif"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
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

//- (void) webViewDidStartLoad:(UIWebView *)webView
//{
//    [self.view addSubview:self.loadingImageView];
//}
//
//- (void) webViewDidFinishLoad:(UIWebView *)webView
//{
//    [self.loadingImageView removeFromSuperview];
//}



@end
