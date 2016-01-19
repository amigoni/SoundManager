//
//  SoundMananger.m
//  SoundManager
//
//  Created by Leonardo Amigoni on 1/18/16.
//  Copyright © 2016 Mozzarello. All rights reserved.
//

#import "SoundMananger.h"

@implementation SoundMananger

#pragma mark -
#pragma mark Initialization methods

+ (SoundMananger*)sharedManager
{
    //Ensuring Singleton
    static SoundMananger *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SoundMananger alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.musicEnabled = YES; //Would set this value from saved property in the future
    }
    
    return self;
}

#pragma mark - Play methods

- (void)playSound :(NSString *)fileName :(NSString *) extension{
    SystemSoundID audioEffect;
    
    NSURL *pathURL = [self getURLfromFileName:fileName :extension];
    if (pathURL) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        
    }
}


- (void) loadMusic: (NSString *)fileName :(NSString *) extension {
    if (!self.backgroundMusicPlayer){
        NSError *error;
        NSURL *backgroundMusicURL = [self getURLfromFileName:fileName :extension];
        if (backgroundMusicURL) {
            self.backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                      initWithContentsOfURL:backgroundMusicURL error:&error];
            self.backgroundMusicPlayer.delegate = self;
            self.backgroundMusicPlayer.numberOfLoops = -1; //Perpetual looping
            [self.backgroundMusicPlayer prepareToPlay];
            
            if (error) {
                NSLog(@"error: %@", error.description);
            }
        }
    }
}


- (void) playMusic {
    [self.backgroundMusicPlayer play];
    self.musicPlaying = YES;
}


- (void) pauseMusic {
    [self.backgroundMusicPlayer pause];
    self.musicPlaying = NO;
}


- (void) stopMusic {
    [_backgroundMusicPlayer stop];
    self.musicPlaying = NO;
}

#pragma mark - Other methods

- (NSURL *) getURLfromFileName: (NSString *)fileName : (NSString * ) extension {
    NSString *path = [[NSBundle mainBundle] pathForResource : fileName ofType :extension];
    NSURL *pathURL = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        pathURL = [NSURL fileURLWithPath: path];
    }
    
    if (!pathURL){
        NSLog(@"error, file not found: %@", path);
    }
    
    return pathURL;
}


@end
