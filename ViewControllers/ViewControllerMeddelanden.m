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

#import "Colors.h"

#import "FuturalAPI.h"
#import "Message.h"
#import "Sektioner.h"

#define TAG_HEADER 1
#define TAG_SEKTION 3
#define TAG_SUBHEADER 2
#define TAG_DATE 4
#define TAG_IMAGE 5


@interface ViewControllerMeddelanden ()

@property (nonatomic) FuturalAPI *api;
@property (nonatomic) NSMutableArray *messages;
@property (nonatomic) NSMutableData *dataQueue;

@end

@implementation ViewControllerMeddelanden

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;

    [self.api fetchNotifications]; //grab the push messages.
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(refreshMessages:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [Colors darkBlueColorWithAlpha:1];
    self.refreshControl = refreshControl;
    
}

- (IBAction)refreshMessages:(id)sender {
    
    [self.messages removeAllObjects];
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [self.api fetchNotifications];
    
}

#pragma mark - SlidingView

- (IBAction)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

#pragma mark - Lazy instanciation

//lazy instantiation
- (NSMutableArray *)messages {
    
    if(!_messages) {
        
        _messages = [[NSMutableArray alloc] init];
        
    }
    
    return _messages;
    
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

#pragma mark DELEGATES

#pragma mark -NSURLConnection
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.dataQueue appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    id parsedData = [[self.api class] parseJSONData:self.dataQueue];
    self.dataQueue = nil;
    
    if(parsedData) {
        
        parsedData = (NSDictionary *)parsedData;
        
        if(parsedData[@"notifications"]) { //check if it's the push messages that is being requested.
            
            NSString *jsonString = parsedData[@"notifications"];
            NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError = nil;
            
            NSArray *messages = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
            
            for(NSDictionary *notification in messages) {
                
                Message *message = [[Message alloc] initWithDictionary:notification];
                [self.messages addObject:message];
                
            }
            
            [self.messagesTable reloadData];
            [self.refreshControl endRefreshing];
        }
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response { //debug
    
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
    
    UILabel *headerLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_HEADER];
    UILabel *sektionerLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_SEKTION];
    UILabel *subheaderLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_SUBHEADER];
    UILabel *dateLabel = (UILabel *)[[cell contentView] viewWithTag:TAG_DATE];
    
    UIImageView *imageView = (UIImageView *)[[cell contentView] viewWithTag:TAG_IMAGE];
    
    headerLabel.text = [message.title uppercaseString];
    Sektioner *sektion = [[Sektioner sektioner] objectForKey:[NSString stringWithFormat:@"%d", (int) message.recipientId]];
    sektionerLabel.text = [sektion.name uppercaseString];
    subheaderLabel.text = message.message;
    dateLabel.text = [message dateAsHumanReadableString];
    imageView.image = [UIImage imageNamed:sektion.img];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
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
