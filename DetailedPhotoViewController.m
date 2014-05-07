//
//  DetailedPhotoViewController.m
//  Camera
//
//  Created by Richard Luong on 2014-04-28.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "DetailedPhotoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailedPhotoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *captionTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailedPhotoViewController

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
    self.title = [self.image.name uppercaseString];
    self.nameLabel.text = self.image.name;
    self.captionTextView.text = self.image.caption;
    //self.captionTextView.textColor = [UIColor redColor];
    
    [self.spinner startAnimating];
    NSURL *url = self.image.url;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.imageView setImageWithURLRequest:request
                           placeholderImage:nil
                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                        
                                        self.imageView.image = image;
                                        self.imageView.hidden = NO;
                                        [self.spinner stopAnimating];
                                        
                                    } failure:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
