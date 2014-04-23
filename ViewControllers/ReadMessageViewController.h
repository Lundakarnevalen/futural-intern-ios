//
//  ReadMessageViewController.h
//  Karnevalisten
//
//  Created by Victor Ingman on 2014-03-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface ReadMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *header;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *informationField;
@property (weak, nonatomic) IBOutlet UILabel *sektionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sektionImageView;

@property (nonatomic, strong) Message *currentMessage;

@end
