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
#import "ReadMessageViewController.h"

#import "FuturalAPI.h"
#import "Message.h"

#define TAG_HEADER 1
#define TAG_SUBHEADER 2

@interface ViewControllerMeddelanden ()

@property (nonatomic) FuturalAPI *api;
@property (nonatomic) NSMutableArray *messages;

@end

@implementation ViewControllerMeddelanden

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.activitySpinner startAnimating];
    [self.api fetchNotifications]; //grab the push messages.
    
}

- (IBAction)refreshMessages:(id)sender {
    
    [self.messages removeAllObjects];
    
    [self.activitySpinner startAnimating];
    [self.api fetchNotifications];
    
}

- (IBAction)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

//lazy instantiation
- (NSMutableArray *)messages {
    
    if(!_messages) {
        
        _messages = [[NSMutableArray alloc] init];
        
    }
    
    return _messages;
    
}

- (FuturalAPI *)api {
    
    if(!_api) {
        
        _api = [[FuturalAPI alloc] initFuturalAPIWithDownloadDelegate:self];
        
    }
    
    return _api;
    
}

#pragma mark DELEGATES

#pragma mark -NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.activitySpinner stopAnimating];
    
    id parsedData = [[self.api class] parseJSONData:data];
    
    if(parsedData) {
        
        parsedData = (NSDictionary *)parsedData;
        
        if(parsedData[@"notifications"]) { //check if it's the push messages that is being requested.
            
            for(NSDictionary *notification in parsedData[@"notifications"]) {
                
                Message *message = [[Message alloc] initWithDictionary:notification];
                [self.messages addObject:message];
                
            }
            
            [self.messagesTable reloadData];
            
        }
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error { //error
    
    [self.activitySpinner stopAnimating];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
    [self.activitySpinner stopAnimating];
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"%@", [httpResponse allHeaderFields]);
    
}

#pragma mark -UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.messages) {
        
        return [self.messages count];
        
    } else {
        
        return 0;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *message = [self.messages objectAtIndex:indexPath.row]; //the push message we want to show.
    
    NSString *cellIdentifier = @"messageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    UILabel * headerLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_HEADER];
    UILabel * subheaderLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_SUBHEADER];
    
    [headerLabel setText:message.title];
    [subheaderLabel setText:[message dateAsHumanReadableString]];
    
    return cell;
    
}

#pragma mark -Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"readMessage"]) {
        
        NSIndexPath* pathOfTheCell = [self.messagesTable indexPathForCell:sender];
        NSInteger rowOfTheCell = [pathOfTheCell row];
        
        ReadMessageViewController *messageVC = (ReadMessageViewController *)segue.destinationViewController;
        messageVC.currentMessage = self.messages[rowOfTheCell];
        
    }
}


@end
