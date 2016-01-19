//
//  ViewController.m
//  SoundManager
//
//  Created by Leonardo Amigoni on 1/18/16.
//  Copyright © 2016 Mozzarello. All rights reserved.
//

#import "ViewController.h"
#import "SoundMananger.h"


@interface ViewController ()

@property (strong, nonatomic) SoundMananger *soundManager;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.soundManager = [SoundMananger sharedManager];
    [self.soundManager loadMusic:@"01 Birabuto Kingdom"  :@"mp3"];
    [self.soundManager playMusic];
}

#pragma mark - Button Actions

- (IBAction)onJumpPressed:(id)sender {
    [self.soundManager playSound:@"smb_jump-small" :@"wav"];
    
    [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        self.mario.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-150);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
        self.mario.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    } completion:^(BOOL finished) {}];
    
    }];
}


- (IBAction)onCoinPressed:(id)sender {
    [self.soundManager playSound:@"smb_coin" :@"wav"];
    
    self.coin.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.coin.hidden = false;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        self.coin.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-200);
    } completion:^(BOOL finished) {self.coin.hidden = true;}
     ];
    
}


- (IBAction)on1UpPressed:(id)sender {
    [self.soundManager playSound:@"smb_1-up" :@"wav"];
    
    self.mushroom.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.mushroom.hidden = false;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        self.mushroom.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2-200);
    } completion:^(BOOL finished) {self.mushroom.hidden = true;}
     ];

    
}


- (IBAction)onMusicButtonPressed:(id)sender {
    if (self.soundManager.musicPlaying){
        [self.soundManager pauseMusic];
        [self.musicButton setTitle:@"Play" forState:UIControlStateNormal];
    } else {
        [self.soundManager playMusic];
        [self.musicButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}


@end
