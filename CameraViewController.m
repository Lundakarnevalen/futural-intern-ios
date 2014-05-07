//
//  ViewController.m
//  Camera
//
//  Created by Richard Luong on 2014-04-21.
//  Copyright (c) 2014 Richard Luong. All rights reserved.
//

#import "CameraViewController.h"
#import "FutuImage.h"
#import "DetailedPhotoViewController.h"
#import "PrepareForUploadViewController.h"
#import "ECSlidingViewController.h"

#import "Models/FuturalAPI.h"
#import "FutuImage.h"

#define TAG_IMAGEVIEW 1001
#define TAG_ACTIVITY 1002

@interface CameraViewController ()

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) FuturalAPI *api;
@property (nonatomic) NSMutableData *dataQueue;

@property (nonatomic, strong) UIImage *image;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh addTarget:self action:@selector(reloadCollectionView) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refresh];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
    
    self.images = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [NSArray arrayWithContentsOfFile:path]) {
        [self.images addObject:[[FutuImage alloc] initWithDictionary:dict]];
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Avbryt"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Ta bild", @"Välj bild", nil];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)reloadCollectionView {
    //[self.images removeAllObjects];
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [self.api fetchNotifications];
    [self.collectionView reloadData];
}

- (IBAction)takePhoto:(id)sender {
    [self.actionSheet showInView:self.view];
}

- (IBAction)shootButtonPressed:(id)sender {
    [self.actionSheet showInView:self.view];
    
}

#pragma mark - collection data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    __weak UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:TAG_IMAGEVIEW];
    __weak UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:TAG_ACTIVITY];
    
    [spinner startAnimating];
    spinner.tintColor = [UIColor blackColor];
    recipeImageView.hidden = YES;
    //recipeImageView.backgroundColor = [UIColor greenColor];
    
    NSURL *url = [[self.images objectAtIndex:indexPath.row] url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    [recipeImageView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       recipeImageView.image = image;
                                       recipeImageView.hidden = NO;
                                       [cell setNeedsLayout];
                                       [spinner stopAnimating];
                                       
                                   } failure:nil];
    
    
    //NSLog(@"r: %d, s: %d", indexPath.row, indexPath.section);
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - ui action sheet delegate 

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        default:
            NSLog(@"The %@ button was tapped.", [actionSheet buttonTitleAtIndex:buttonIndex]);
            break;
    }
    
    
}

#pragma mark - collection delegate

#pragma mark - imagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.image = info[UIImagePickerControllerEditedImage];
    
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Bild tagen"
//                                                          message:@"Bild är tagen."
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles: nil];
    
    //[myAlertView show];
    
    [picker dismissViewControllerAnimated:YES completion:^(void) { [self performSegueWithIdentifier:@"toPrepareForUploadSegue" sender:self]; }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - navigation delegates 

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetailedPhotoViewSegue"]) {
        DetailedPhotoViewController *view = (DetailedPhotoViewController *)[segue destinationViewController];
        view.image = [self.images objectAtIndex:[[self.collectionView indexPathForCell:sender] row]];
    } else if ([segue.identifier isEqualToString:@"toPrepareForUploadSegue"]) {
        UINavigationController *navView = ((UINavigationController *)[segue destinationViewController]);
        PrepareForUploadViewController *view = (PrepareForUploadViewController *)navView.viewControllers[0];
        view.image = self.image;
    }
}

#pragma mark -NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.dataQueue appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    [self.refresh endRefreshing];
    
    id parsedData = [[self.api class] parseJSONData:self.dataQueue];
    self.dataQueue = nil;
    
    if(parsedData) {
        
        parsedData = (NSDictionary *)parsedData;
        
        if(parsedData[@"photos"]) { //check if it's the push messages that is being requested.
            
            NSString *jsonString = parsedData[@"photos"];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError = nil;
            
            NSArray *photos = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
            
            for (NSDictionary *dictionary_photos in photos) {
                FutuImage *photos = [[FutuImage alloc] initWithDictionary:dictionary_photos];
                [self.images addObject:photos];
            }
            
        }
        
        [self.collectionView reloadData];
        
    }
    
}

#pragma mark - lazy instanceiation

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
    //[self.activitySpinner stopAnimating];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
}

- (NSMutableData *)dataQueue {
    
    if(!_dataQueue) {
        
        _dataQueue = [[NSMutableData alloc] init];
        
    }
    
    return _dataQueue;
    
}

- (FuturalAPI *)api {
    
    if(!_api) {
        
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
        
    }
    
    return _api;
    
}
- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
