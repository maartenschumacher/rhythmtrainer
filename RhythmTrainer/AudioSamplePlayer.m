//
//  AudioSamplePlayer.m
//  openaltest
//
//  Created by Maarten Schumacher on 9/25/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "AudioSamplePlayer.h"
#import "ViewController.h"
#include <stdlib.h>

#define kMaxConcurrentSources 32
#define kMaxBuffers 256
#define kSampleRate 44100

@implementation AudioSamplePlayer

static ALCdevice *openALdevice;
static ALCcontext *openALcontext;
static NSDictionary *scale;
static NSArray *melodynotes;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.melody = [[Melody alloc]init];
        
        openALdevice = alcOpenDevice(NULL);
        
        openALcontext = alcCreateContext(openALdevice, NULL);
        alcMakeContextCurrent(openALcontext);
        
        ALuint sourceID;
        self.audioSampleBuffers = [[NSMutableDictionary alloc]init];
        self.audioSampleSources = [[NSMutableArray alloc]initWithObjects:nil];
        for (int i = 0; i < kMaxConcurrentSources; i++) {
            alGenSources(1, &sourceID);
            [self.audioSampleSources addObject:[NSNumber numberWithUnsignedInt:sourceID]];
        }
    }
    return self;
}

+(AudioSamplePlayer *)getInstance {
    static AudioSamplePlayer *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[AudioSamplePlayer alloc]init];
        }
    }
    return instance;
}

-(void)userDidClickPlayAt:(NSInteger)clickedTime WithMeter:(NSInteger)meter {
    NSString *sampleName = @"sinesample4";
    bool withPitch = YES;
    
    float pitch = 1.0f;
    if (withPitch == YES) {
        pitch = [self.melody getPitchForTime:clickedTime WithMeter:meter];
    }
    
    [self playAudioSample:sampleName withPitch:pitch];
    
}

-(void)preLoadAudioSample:(NSString *)sampleName {
    if ([self.audioSampleBuffers objectForKey:sampleName]) {
        return;
    }
    
    if ([self.audioSampleBuffers count] > kMaxBuffers) {
        NSLog(@"error, too many buffers");
        return;
    }
    
    NSString *audioFilePath = [[NSBundle mainBundle]pathForResource:sampleName ofType:@"caf"];
    
    AudioFileID afid = [self openAudioFile:audioFilePath];
    
    UInt32 audioFileSizeInBytes = [self getSizeOfAudioComponent:afid];
    
    void *audioData = malloc(audioFileSizeInBytes);
    
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &audioFileSizeInBytes, audioData);
    
    if (0 != readBytesResult)
    {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %d", audioFilePath, (int)readBytesResult);
    }
    
    AudioFileClose(afid);
    
    ALuint outputBuffer;
    alGenBuffers(1, &outputBuffer);
    
    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, audioFileSizeInBytes, kSampleRate);
    
    [self.audioSampleBuffers setObject:[NSNumber numberWithUnsignedInt:outputBuffer] forKey:sampleName];
    
    if (audioData) {
        free(audioData);
        audioData = NULL;
    }
}

- (AudioFileID) openAudioFile:(NSString *)audioFilePathAsString
{
    NSURL *audioFileURL = [NSURL fileURLWithPath:audioFilePathAsString];
    
    AudioFileID afid;
    OSStatus openAudioFileResult = AudioFileOpenURL((__bridge CFURLRef)audioFileURL, kAudioFileReadPermission, 0, &afid);
    
    if (0 != openAudioFileResult)
    {
        NSLog(@"An error occurred when attempting to open the audio file %@: %d", audioFilePathAsString, (int)openAudioFileResult);
        
    }
    
    return afid;
}

- (UInt32) getSizeOfAudioComponent:(AudioFileID)afid
{
    UInt64 audioDataSize = 0;
    UInt32 propertySize = sizeof(UInt64);
    
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propertySize, &audioDataSize);
    
    if (0 != getSizeResult)
    {
        NSLog(@"An error occurred when attempting to determine the size of audio file.");
    }
    
    return (UInt32)audioDataSize;
}

- (void) playAudioSample:(NSString *)sampleName withPitch:(float)pitch
{
    ALuint source = [self getNextAvailableSource];
    
    alSourcef(source, AL_PITCH, pitch);
    alSourcef(source, AL_GAIN, 0.8f);
    
    ALuint outputBuffer = (ALuint)[[self.audioSampleBuffers objectForKey:sampleName] intValue];
    
    alSourcei(source, AL_BUFFER, outputBuffer);
    
    alSourcePlay(source);
}

- (ALuint) getNextAvailableSource
{
    ALint sourceState;
    for (NSNumber *sourceID in self.audioSampleSources) {
        alGetSourcei([sourceID unsignedIntValue], AL_SOURCE_STATE, &sourceState);
        if (sourceState != AL_PLAYING)
        {
            return [sourceID unsignedIntValue];
        }
    }
    
    ALuint sourceID = [[self.audioSampleSources objectAtIndex:0] intValue];
    alSourceStop(sourceID);
    return sourceID;
}

- (void) shutdownAudioSamplePlayer
{
    ALint source;
    for (NSNumber *sourceValue in self.audioSampleSources)
    {
        ALuint sourceID = [sourceValue unsignedIntValue];
        alGetSourcei(sourceID, AL_SOURCE_STATE, &source);
        alSourceStop(sourceID);
        alDeleteSources(1, &sourceID);
    }
    [self.audioSampleSources removeAllObjects];
    
    NSArray *bufferIDs = [self.audioSampleBuffers allValues];
    for (NSNumber *bufferValue in bufferIDs)
    {
        ALuint bufferID = [bufferValue unsignedIntValue];
        alDeleteBuffers(1, &bufferID);
    }
    [self.audioSampleBuffers removeAllObjects];
    
    alcDestroyContext(openALcontext);
    
    alcCloseDevice(openALdevice);
}

@end
