//
//  AudioSamplePlayer.h
//  openaltest
//
//  Created by Maarten Schumacher on 9/25/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#include <AudioToolbox/AudioToolbox.h>
#import "Melody.h"

@interface AudioSamplePlayer : NSObject

@property NSMutableDictionary *audioSampleBuffers;
@property NSMutableArray *audioSampleSources;
@property Melody *melody;

+(AudioSamplePlayer *)getInstance;
-(void)userDidClickPlayAt:(NSInteger)clickedTime WithMeter:(NSInteger)meter;
-(UInt32) getSizeOfAudioComponent:(AudioFileID)afid;
-(AudioFileID) openAudioFile:(NSString *)audioFilePathAsString;
-(void)preLoadAudioSample:(NSString *)sampleName;
-(ALuint) getNextAvailableSource;
-(void) shutdownAudioSamplePlayer;
-(void) playAudioSample:(NSString *)sampleName withPitch:(float)pitch;


@end
