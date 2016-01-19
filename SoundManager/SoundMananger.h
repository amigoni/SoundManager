//
//  SoundMananger.h
//  SoundManager
//
//  Created by Leonardo Amigoni on 1/18/16.
//  Copyright © 2016 Mozzarello. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface SoundMananger : NSObject

+(SoundMananger*) sharedManager;

@property (strong,nonatomic) AVAudioPlayer *musicPlayer;
@property BOOL musicPlaying;
@property BOOL musicEnabled;

- (void) playSound: (NSString *)fileName : (NSString *)extension;
- (void) loadMusic: (NSString *)fileName : (NSString *)extension;
- (void) playMusic;
- (void) pauseMusic;
- (void) stopMusic;

@end

