//
//  DetailedSongViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "DetailedSongViewController.h"

@interface DetailedSongViewController ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *melodyLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *isWinnerImageView;


@end

@implementation DetailedSongViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [self.song.name uppercaseString];
    self.nameLabel.text = self.song.name;
    if (self.song.melodi) {
        self.melodyLabel.text = self.song.melodi;
    } else {
        self.melodyLabel.hidden = YES;
    }
    
    self.isWinnerImageView.hidden = !self.song.isWinner;
    
    self.imageView.image = self.song.img;
    self.textView.text = self.song.text;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%@", self.song.pageNumber];
    // Do any additional setup after loading the view.
}

@end
