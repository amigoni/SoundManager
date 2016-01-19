//
//  SoundMananger.m
//  SoundManager
//
//  Created by Leonardo Amigoni on 1/18/16.
//  Copyright © 2016 Mozzarello. All rights reserved.
//

#import "SoundMananger.h"

@implementation SoundMananger

+ (SoundMananger*)sharedManager
{
    static SoundMananger *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SoundMananger alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _musicEnabled = YES; //Would set this value from saved property in the future
    }
    return self;
}

- (void)playSound :(NSString *)fileName :(NSString *) extension{
    SystemSoundID audioEffect;
    
    NSURL *pathURL = [self getURLfromFileName:fileName :extension];
    if (pathURL) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
        
    }
}


- (void) loadMusic: (NSString *)fileName :(NSString *) extension {
    if (!_backgroundMusicPlayer){
        NSError *error;
        NSURL *backgroundMusicURL = [self getURLfromFileName:fileName :extension];
        if (backgroundMusicURL) {
            _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                      initWithContentsOfURL:backgroundMusicURL error:&error];
            _backgroundMusicPlayer.delegate = self;
            _backgroundMusicPlayer.numberOfLoops = -1; //Perpetual looping
            [_backgroundMusicPlayer prepareToPlay];
            
            if (error) {
                NSLog(@"error: %@", error.description);
            }
        }
    }
}

- (void) playMusic {
    [_backgroundMusicPlayer play];
    _musicPlaying = YES;
}


- (void) pauseMusic {
    [_backgroundMusicPlayer pause];
    _musicPlaying = NO;
}


- (void) stopMusic {
    [_backgroundMusicPlayer stop];
    _musicPlaying = NO;
}


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
