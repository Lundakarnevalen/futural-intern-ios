//
//  MainViewController.m
//  SlideMenu
//
//  Created by Kyle Begeman on 1/13/13.
//  Copyright (c) 2013 Indee Box LLC. All rights reserved.
//

#import "MainViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import "LyricString.h"

#import "Lundakarneval.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *karnevalenLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabelMain;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *checkmarks;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *timeLabels;

@property (strong,nonatomic) AVAudioPlayer *player;

@property (strong, nonatomic) NSArray *lyric;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lyricStringCollection;

@property (weak, nonatomic) IBOutlet UILabel *rowForLyricLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowMinus1LyricLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowPlus1LyricLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerPin;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;

@property (nonatomic) NSUInteger rowCount;

@end

@implementation MainViewController

-(void)viewDidLoad {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] registerForPushNotifications];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] startLocationManager];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont fontWithName:@"Robot!Head" size:26.0], NSFontAttributeName,[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil];
    
    [self updateTimerLabels];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(updateTimerLabels)
                                                         userInfo:nil
                                                          repeats:YES];
    
    self.musicTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateCurrentTime) userInfo:self.player repeats:YES];
    
}

#pragma mark timer for labels

-(void)updateTimerLabels {
    
    //NSLog(@"\nTid kvar: %@", [Lundakarneval timeLeftUntil:@"lundakarnevalen"]);
    self.timeLabelMain.text = [Lundakarneval timeLeftUntil:@"lundakarnevalen"];
    
    for (int i = 0; i < [self.timeLabels count]; i++) {
        UILabel *temp = [self.timeLabels objectAtIndex:i];
        switch (i) {
            case 0:
                temp.text = [Lundakarneval timeLeftUntil:@"tidningsdagen"];
                break;
            case 1:
                temp.text = [Lundakarneval timeLeftUntil:@"karnelan"];
                break;
            case 2:
                temp.text = [Lundakarneval timeLeftUntil:@"karnevöl_systemet"];
                break;
            case 3:
                temp.text = [Lundakarneval timeLeftUntil:@"förkarneval"];
                break;
            default:
                break;
        }
        if ([temp.text isEqual:@"00:00:00:00"]) {
            UIImageView *imageview = [self.checkmarks objectAtIndex:i];
            imageview.hidden = NO;
        }
    }
    
}

- (void)stopCountdownTimer {
    
    if(self.countdownTimer) {
        
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
        
    }
    
}

#pragma mark - Sliding view

- (IBAction)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

#pragma mark - Song

-(void)updateCurrentTime {
    //self.durationLabel.text = [NSString stringWithFormat:@"%f", self.player.currentTime];
    
    CGRect myFrame = self.playerPin.frame;
    //NSLog(@"%f", self.player.currentTime * (190.0 / 214.0));
    myFrame.origin.x = 92.0 + self.player.currentTime * (180.0 / 214.0);
    self.playerPin.frame = myFrame;
    
    if (self.rowCount < [self.lyric count]) {
        LyricString *ls = [self.lyric objectAtIndex:self.rowCount];
        if (self.player.currentTime > ls.time) {
            [self nextRow];
        }
    }
}

- (void)stopMusicTimer { //stop the timer if necessary
    
    if(self.musicTimer) {
        
        //reset the player pin and stop the music maybe?
        
        [self.musicTimer invalidate];
        self.musicTimer = nil;
        
    }
    
}

- (IBAction)playButtonPressed:(id)sender {

    [self togglePlayPause];

}

- (void)togglePlayPause {
    
    BOOL isPlaying = [self.player isPlaying];
    
    
    self.timeLabelMain.hidden = !isPlaying;
    self.karnevalenLabel.hidden = !isPlaying;
    for(UIView *row in self.lyricStringCollection) {
        row.hidden = isPlaying;
    }
    
    if(isPlaying) {
        [self.player pause];
        [self.playPauseButton setImage:[UIImage imageNamed:@"PlayerButton"] forState:UIControlStateNormal];
    } else {
        [self.playPauseButton setImage:[UIImage imageNamed:@"PauseButton"] forState:UIControlStateNormal];
        [self.player play];
        self.rowCount = 0;
    }
    
}

-(AVAudioPlayer *)player {
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"karnevalsmelodin" ofType:@"mp3"]];
    
    if (!_player) _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    return _player;
}

-(void)nextRow {
    if (self.rowCount < [self.lyric count]) {
        LyricString *ls = [self.lyric objectAtIndex:(self.rowCount)];
        self.rowForLyricLabel.text = ls.str;
        if ((self.rowCount) > 0) {
            LyricString *ls = [self.lyric objectAtIndex:(self.rowCount-1)];
            self.rowMinus1LyricLabel.text = ls.str;
        }
        if (self.rowCount < [self.lyric count]-1) {
            LyricString *ls = [self.lyric objectAtIndex:(self.rowCount+1)];
            self.rowPlus1LyricLabel.text = ls.str;
        } else {
            self.rowPlus1LyricLabel.text = @"";
        }
    }
    self.rowCount++;
}

-(NSArray *)lyric {
    if (!_lyric) {
        _lyric = [[NSArray alloc] initWithObjects:
                  [[LyricString alloc] initWithString:@"jag kan inte sitta still" time:0],
                  [[LyricString alloc] initWithString:@"jag får inte någon ro" time:11],
                  [[LyricString alloc] initWithString:@"nu är längtan över" time:14.780363],
                  [[LyricString alloc] initWithString:@"jag sätter allt på paus" time:17.764671],
                  [[LyricString alloc] initWithString:@"det är något som är på gång" time:22.379864],
                  [[LyricString alloc] initWithString:@"har aldrig känt så här förut" time:26.264580],
                  [[LyricString alloc] initWithString:@"glömmer allt som var" time:29.397075],
                  [[LyricString alloc] initWithString:@"det är karneval" time:32.797188],
                  [[LyricString alloc] initWithString:@"med hjärtslagen i takt till basen" time:37.159637],
                  [[LyricString alloc] initWithString:@"lyfter händerna mot taken" time:40.797075],
                  [[LyricString alloc] initWithString:@"ingen sömn på flera nätter" time:44.715850],
                  [[LyricString alloc] initWithString:@"aldrig känt mig mer vaken" time:48.480340],
                  [[LyricString alloc] initWithString:@"det är nu i vår det händer" time:52.130476],
                  [[LyricString alloc] initWithString:@"det är vart fjärde år" time:54.446168],
                  [[LyricString alloc] initWithString:@"kom möt upp nu alla vänner" time:56.114875],
                  [[LyricString alloc] initWithString:@"kom och skrik i Lundagård" time:57.964853],
                  [[LyricString alloc] initWithString:@"ljusen bländar, hjärtat bultar" time:59.847755],
                  [[LyricString alloc] initWithString:@"nu är det fest i lund" time:62.030408],
                  [[LyricString alloc] initWithString:@"exploderar på en sekund" time:63.614694],
                  [[LyricString alloc] initWithString:@"futu futu" time:68.430340],
                  [[LyricString alloc] initWithString:@"ral" time:71.014717],
                  [[LyricString alloc] initWithString:@"karneval" time:74.146190],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:75.447075],
                  [[LyricString alloc] initWithString:@"ral" time:78.564853],
                  [[LyricString alloc] initWithString:@"karneval" time:81.614399],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:82.8],
                  [[LyricString alloc] initWithString:@"ett universium flyttar allt" time:84.627823],
                  [[LyricString alloc] initWithString:@"hundra fester på en dag" time:88.410204],
                  [[LyricString alloc] initWithString:@"nu är gammalt nytt" time:91.430771],
                  [[LyricString alloc] initWithString:@"och generalen har fått bröst" time:94.197075],
                  [[LyricString alloc] initWithString:@"karnevölen fyller glasen" time:99.446916],
                  [[LyricString alloc] initWithString:@"vem vet något om morgondagen" time:102.880385],
                  [[LyricString alloc] initWithString:@"alla dansar, borgen skakar" time:106.947166],
                  [[LyricString alloc] initWithString:@"aldrig känt mig mer vaken" time:110.464444],
                  [[LyricString alloc] initWithString:@"det är nu i vår det händer" time:114.447143],
                  [[LyricString alloc] initWithString:@"det är vart fjärde år" time:116.330340],
                  [[LyricString alloc] initWithString:@"kom möt upp nu alla vänner" time:118.114467],
                  [[LyricString alloc] initWithString:@"kom och skrik i Lundagård" time:120.014467],
                  [[LyricString alloc] initWithString:@"ljusen bländar, hjärtat bultar" time:121.847098],
                  [[LyricString alloc] initWithString:@"nu är det fest i Lund" time:124.030317],
                  [[LyricString alloc] initWithString:@"exploderar på en sekund" time:125.630748],
                  [[LyricString alloc] initWithString:@"futu futu" time:130.197029],
                  [[LyricString alloc] initWithString:@"ral" time:132.830363],
                  [[LyricString alloc] initWithString:@"karneval" time:135.947075],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:137.214354],
                  [[LyricString alloc] initWithString:@"ral" time:140.364444],
                  [[LyricString alloc] initWithString:@"karneval" time:143.514308],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:146.210771],
                  [[LyricString alloc] initWithString:@"oo aaa hh" time:150],
                  [[LyricString alloc] initWithString:@"oo aaa hh" time:153.247120],
                  [[LyricString alloc] initWithString:@"det är vår när det händer" time:161.280476],
                  [[LyricString alloc] initWithString:@"det är vart fjärde år" time:163.230476],
                  [[LyricString alloc] initWithString:@"vi är allesammans vänner" time:164.897506],
                  [[LyricString alloc] initWithString:@"skiker ut i Lundagård" time:166.797551],
                  [[LyricString alloc] initWithString:@"vi ska övertyga världen" time:168.647029],
                  [[LyricString alloc] initWithString:@"att fira maj i Lund" time:170.880385],
                  [[LyricString alloc] initWithString:@"exploderar på en sekund" time:172.480340],
                  [[LyricString alloc] initWithString:@"futu futu" time:177.248730],
                  [[LyricString alloc] initWithString:@"ral" time:179.831678],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:184.731973],
                  [[LyricString alloc] initWithString:@"ral" time:187.331633],
                  [[LyricString alloc] initWithString:@"karneval" time:190.298571],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:191.715283],
                  [[LyricString alloc] initWithString:@"ral" time:194.715442],
                  [[LyricString alloc] initWithString:@"karneval" time:197.778254],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:199.227982],
                  [[LyricString alloc] initWithString:@"ral" time:202.444853],
                  [[LyricString alloc] initWithString:@"karneval" time:205.217370],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:206.751224],
                  [[LyricString alloc] initWithString:@"ral" time:209.868844],
                  [[LyricString alloc] initWithString:@"karneval" time:212.884286],
                  [[LyricString alloc] initWithString:@"futu futu futu" time:214.183878], nil];
    }
    
    return _lyric;
}


@end
