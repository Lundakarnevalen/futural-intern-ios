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

- (FuturalAPI *)api { //lazy instantiation
    
    if(!_api) {
        
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
        
    }
    
    return _api;
    
}

#pragma mark DELEGATES

#pragma mark -NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.activityIndicator stopAnimating];
    self.signinButton.hidden = NO;
    
    NSString *stringIdentifier = [[self.api class] stringIdentifierFromUrlConnection:connection]; //class method.
    id parsedData = [[self.api class] parseJSONData:data];
    
    if(parsedData) { //api returned a json-object
        
        parsedData = (NSDictionary *)parsedData;
        NSLog(@"%@", parsedData); //debug
        
        if([stringIdentifier isEqualToString:@"sign_in"]) { //sign in.
            
            NSLog(@"%@", parsedData[@"success"]);
            
            if(parsedData[@"success"] != nil) {
                
                NSString *requestedToken = parsedData[@"token"];
                NSDictionary *karnevalist = parsedData[@"karnevalist"];
                
                [self.api.karnevalist setToken:requestedToken];
                [self.api.karnevalist setInformationFromDictionary:karnevalist];
                
                [self performSegueWithIdentifier:@"signedIn" sender:self];
                
            } else {
                
                NSDictionary *errors = parsedData[@"errors"];
                
                for(NSString *error in errors) { //ful-fix, inte säker på hur jag får ut första.
                    
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
