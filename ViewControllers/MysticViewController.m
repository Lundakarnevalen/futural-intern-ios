//
//  MysticViewController.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-04-23.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MysticViewController.h"
#import "ShakingView.h"

@interface MysticViewController ()

@property (strong, nonatomic) IBOutlet ShakingView *shakeView;
@property (strong, nonatomic) IBOutlet UIView *questionsView;
@property (strong, nonatomic) IBOutlet UIView *answersView;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;

@property (strong,  nonatomic) NSArray *answers;

@end

@implementation MysticViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                                   [UIFont fontWithName:@"FuturaLT-Bold" size:17.0], NSFontAttributeName,[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil];
    self.answers = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"strings" ofType:@"plist"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidShake:) name:DeviceDidShake object:nil];

}

- (IBAction)didTapAnswersView:(id)sender {
    if (self.answersView.alpha == 1) {
        [self removeAnswer];
    }
}

-(void)deviceDidShake:(NSNotification *)notification {
    NSLog(@"View controller received shake gesture.");
    if (self.answersView.alpha == 0) {
        [self addAnswer];
    } else {
        [self removeAnswer];
    }
}

-(void)addAnswer {
    self.answerLabel.text = [self.answers objectAtIndex:(arc4random() % [self.answers count])];
    [UIView animateWithDuration:1
                     animations:^(void) { self.navigationController.navigationBar.alpha = 0; self.answersView.alpha = 1; }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1 animations:^(void) { self.answerLabel.alpha = 1; }];
                     }
     ];
}

-(void)removeAnswer {
    
        [UIView animateWithDuration:0.5
                         animations:^(void) { self.navigationController.navigationBar.alpha = 1; self.answersView.alpha = 0; self.answerLabel.alpha = 0; }
                         completion:nil];

}

- (void) viewWillAppear:(BOOL)animated
{
    [self.shakeView becomeFirstResponder];
    [super viewWillAppear:animated];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [self.shakeView resignFirstResponder];
    [super viewWillDisappear:animated];
}

@end
