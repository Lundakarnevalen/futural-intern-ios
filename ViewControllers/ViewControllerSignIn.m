//
//  ViewControllerWebView.m
//  Karnevalist2014
//
//  Created by contributeshopping on 2014-01-29.
//  Copyright (c) 2014 Indee Box LLC. All rights reserved.
//

#import "ViewControllerSignIn.h"
#import "ECSlidingViewController.h"
#import "Colors.h"

#import "AppDelegate.h"

@interface ViewControllerSignIn ()

@property (weak, nonatomic) IBOutlet UIView *afterResetPasswordView;
@property (nonatomic) NSMutableData *dataQueue; //used when recieving data from the API.
@property (nonatomic) UITextField *currentResponder;
@property (weak, nonatomic) IBOutlet UILabel *resetPasswordErrorLabel;
@property (weak, nonatomic) IBOutlet UIView *resetPasswordErrorLabelShadow;
@property (weak, nonatomic) IBOutlet UIView *createPasswordButtonView;


@end

@implementation ViewControllerSignIn

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIFont fontWithName:@"FuturaLT-Bold" size:17.0], NSFontAttributeName,[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil];
    
    self.navigationController.navigationBar.topItem.title = [self.navigationController.navigationBar.topItem.title uppercaseString];
    
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



- (void)signIn {
    
    //self.signinButton.hidden = YES;
    self.errorMessageLabel.hidden = YES;
    //[self.activityIndicator startAnimating];
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
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
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
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Start" bundle:nil];
                UIViewController *newTopViewController = [storyboard instantiateInitialViewController];
                
                [(AppDelegate *)[[UIApplication sharedApplication] delegate] startLocationManager];
                
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = newTopViewController;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];                
                
            } else {
                
                NSDictionary *errors = parsedData[@"errors"];
                
                for(NSString *error in errors) { //ful-fix, inte säker på hur jag får ut första i ett dictionary.
                    
                    NSLog(@"%@", error);
                    [self.errorMessageLabel setText:@"Fel email/lösenord."];
                    break;
                    
                }
                
                self.errorMessageLabel.hidden = NO;
                
            }
            
        }
        
        if([stringIdentifier isEqualToString:@"reset_password"]) {
            
            self.createPasswordButtonView.hidden = NO;
            NSLog(@"%@", parsedData[@"success"]);
            
            if([parsedData[@"success"] isEqualToNumber:@1]) {
                NSLog(@"Tjoho!");
                self.afterResetPasswordView.hidden = NO;
            } else {
                NSLog(@"%@", parsedData[@"errors"]);
                for(NSString *error in parsedData[@"errors"]) { //ful-fix, inte säker på hur jag får ut första i ett dictionary.
                    
                    NSLog(@"%@", error);
                    //[self.errorMessageLabel setText:@"Fel email/lösenord."];
                    break;
                    
                }
                self.resetPasswordErrorLabel.text = @"Din email kunde inte hittas.";
                self.resetPasswordErrorLabelShadow.hidden = NO;
                self.resetPasswordErrorLabel.hidden = NO;
            
            }
            
        }
        
        if([stringIdentifier isEqualToString:@"sign_out"]) {
            
            if([parsedData[@"success"] isEqualToString:@"true"]) {
                
                //to be continued.
                
            }
            
        }
        
    }
    
}

#pragma mark - Futural API

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { //error
    
    NSLog(@"Fudge:\n %@", error);
    
}


#pragma mark - buttons
- (IBAction)okayIUnderstandButton:(UIButton *)sender {
    [UIView animateWithDuration:0.3f delay:0.1f options:0
                     animations:^{sender.superview.superview.alpha = 0.0;}
                     completion:nil];
}

- (IBAction)signInButtonTapped:(id)sender {
    self.signinButton.hidden = YES;
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [self resignOnTap:sender];
    [self signIn];
}

- (IBAction)passwordResetAction:(id)sender {
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [self resignOnTap:sender];
    self.createPasswordButtonView.hidden = YES;
    [self.api resetPassword:[self.forgotEmailField text]];
    self.resetPasswordErrorLabelShadow.hidden = YES;
    self.resetPasswordErrorLabel.hidden = YES;
}

- (IBAction)view2Pressed:(id)sender {
    [self resignOnTap:sender];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signoutAction:(id)sender {
    
    [self.api signOut];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}

//Implement resignOnTap:

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

#pragma mark -UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //[self signIn];
    [textField resignFirstResponder];
    return YES;
    
}

@end
