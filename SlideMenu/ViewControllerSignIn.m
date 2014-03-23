//
//  ViewControllerWebView.m
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-29.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "ViewControllerSignIn.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface ViewControllerSignIn ()

@property UIActivityIndicatorView *spinner;

@property (nonatomic) NSMutableData *dataQueue; //used when recieving data from the API.

@end

@implementation ViewControllerSignIn

- (IBAction)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //delegate textfields
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    //padding the textfields.
    self.emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.emailField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.nameLabel setText:self.api.karnevalist.firstname];
    
}
- (IBAction)signInButtonTapped:(id)sender {

    [self signIn];

}

- (void)signIn {
    
    self.signinButton.hidden = YES;
    self.errorMessageLabel.hidden = YES;
    [self.activityIndicator startAnimating];
    [self.api authenticateUser:[self.emailField text] withPassword:[self.passwordField text]];
    
}

#pragma mark LAZYINSTANTIATIONS

- (FuturalAPI *)api {
    
    if(!_api) {
        
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
        
    }
    
    return _api;
    
}

- (NSMutableData *)dataQueue {
    
    if(!_dataQueue) {
        
        _dataQueue = [[NSMutableData alloc] init];
        
    }
    
    return _dataQueue;
    
}

#pragma mark DELEGATES

#pragma mark -NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data { //collects the data.
    
    [self.dataQueue appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { //the request is finished and all the data is stored inside of self.dataQueue
    
    [self.activityIndicator stopAnimating];
    self.signinButton.hidden = NO;
    
    NSString *stringIdentifier = [[self.api class] stringIdentifierFromUrlConnection:connection]; //class method.
    
    id parsedData = [[self.api class] parseJSONData:self.dataQueue];
    self.dataQueue = nil; //remove the used data.
    
    if(parsedData) { //api returned a json-object
        
        parsedData = (NSDictionary *)parsedData;
        
        if([stringIdentifier isEqualToString:@"sign_in"]) { //sign in.
            
            NSLog(@"%@", parsedData[@"success"]);
            
            if([parsedData[@"success"] isEqualToNumber:@1]) {
                
                NSString *requestedToken = parsedData[@"token"];
                NSDictionary *karnevalist = parsedData[@"karnevalist"];
                
                [self.api.karnevalist setToken:requestedToken];
                [self.api.karnevalist setInformationFromDictionary:karnevalist andSave:YES];
                
                [self performSegueWithIdentifier:@"signedIn" sender:self];
                
            } else {
                
                NSDictionary *errors = parsedData[@"errors"];
                
                for(NSString *error in errors) { //ful-fix, inte säker på hur jag får ut första i ett dictionary.
                    
                    [self.errorMessageLabel setText:error];
                    break;
                    
                }
                
                self.errorMessageLabel.hidden = NO;
                
            }
            
        }
        
        if([stringIdentifier isEqualToString:@"sign_out"]) {
            
            if([parsedData[@"success"] isEqualToString:@"true"]) {
                
                //to be continued.
                
            }
            
        }
        
    }
    
}

- (IBAction)passwordResetAction:(id)sender {
    
    [self.api resetPassword];
    
}

- (IBAction)signoutAction:(id)sender {
    
    [self.api signOut];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { //error
    
    NSLog(@"Fudge:\n %@", error);
    
}

#pragma mark -UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self signIn];
    [textField resignFirstResponder];
    
    return YES;
    
}

@end
