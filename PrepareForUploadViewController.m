//
//  PrepareForUploadViewController.m
//  Camera
//
//  Created by Richard Luong on 2014-04-29.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "PrepareForUploadViewController.h"
#import "AFHTTPRequestOperationManager.h"

#import "FuturalAPI.h"

@interface PrepareForUploadViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@property (strong, nonatomic) FuturalAPI *api;

@end

@implementation PrepareForUploadViewController

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
    
    self.imageView.image = self.image;
    [self.spinner stopAnimating];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.5);
    NSDictionary *parameters = @{@"token": [[self.api karnevalist] token], @"photo[caption]": self.captionTextField.text};
    AFHTTPRequestOperation *op = [manager POST:@"http://posttestserver.com/post.php?dir=karneval" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}
- (FuturalAPI *)api {
    
    if(!_api) {
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
    }
    
    return _api;
    
}



@end
