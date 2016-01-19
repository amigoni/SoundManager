//
//  SoundMananger.m
//  SoundManager
//
//  Created by Leonardo Amigoni on 1/18/16.
//  Copyright © 2016 Mozzarello. All rights reserved.
//

#import "SoundMananger.h"

@interface SoundMananger() <AVAudioPlayerDelegate>

@property NSMutableDictionary *soundsIDs;

@end

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
    SystemSoundID soundID;
    
    NSURL *pathURL = [self getURLfromFileName:fileName :extension];
    
    if (pathURL) {
        soundID = (SystemSoundID)self.soundsIDs[pathURL];
        if (soundID) {
            AudioServicesPlaySystemSound(soundID);
        } else {
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &soundID);
            NSNumber *num  = [[NSNumber alloc] initWithUnsignedLong:soundID];
            [self.soundsIDs setValue: num forKey:(NSString *)pathURL];
            AudioServicesPlaySystemSound(soundID);
        }
    }
}


- (void) loadMusic: (NSString *)fileName :(NSString *) extension {
    if (!self.musicPlayer){
        NSError *error;
        NSURL *musicURL = [self getURLfromFileName:fileName :extension];
        if (musicURL) {
            self.musicPlayer = [[AVAudioPlayer alloc]
                                      initWithContentsOfURL:musicURL error:&error];
            self.musicPlayer.delegate = self;
            self.musicPlayer.numberOfLoops = -1; //Perpetual looping
            [self.musicPlayer prepareToPlay];
            
            if (error) {
                NSLog(@"error: %@", error.description);
            }
        }
    }
}


- (void) playMusic {
    [self.musicPlayer play];
    self.musicPlaying = YES;
}


- (void) pauseMusic {
    [self.musicPlayer pause];
    self.musicPlaying = NO;
}


- (void) stopMusic {
    [self.musicPlayer stop];
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
