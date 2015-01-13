//
//  ScoreViewController.h
//  openaltest
//
//  Created by Maarten Schumacher on 10/2/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//
//  Abstract class!

#import <UIKit/UIKit.h>
#import "Rhythm.h"
#import "MeterBehavior.h"
#import "ComposeBehavior.h"
#import "AudioSamplePlayer.h"

@interface ScoreViewController : UIViewController 

@property (nonatomic, weak) id delegate;
@property Rhythm *rhythmInstance;

@property NSInteger currentLevel;
@property NSInteger currentLevelIteration;
@property NSArray *currentRhythm;

@property NSMutableArray *correctBeats;

@property id<MeterBehavior> meterBehavior;
@property id<ComposeBehavior> composeBehavior;

-(void)changeLevel;

//subclassing

-(void)highlightBeat:(NSInteger)clickedBeat;
-(void)userDidClickPlay;
-(void)checkLevelIteration;

@end
