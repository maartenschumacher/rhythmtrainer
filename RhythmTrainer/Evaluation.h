//
//  Evaluation.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 18/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarDidEnd.h"
#import "UserDidClickPlay.h"

@interface Evaluation : NSObject

@property double averageDifference;
@property double hitsPercentage;
@property double tooSoonPercentage;
@property NSInteger numberOfClicks;

@property NSMutableArray *barEnds;
@property NSMutableArray *userClicks;

-(void)updateCurrentStats;
-(NSMutableArray *)checkForAchievements;
-(void)loadStatistics;
-(void)saveStatistics;

+(Evaluation *)getInstance;
-(void)addBarDidEnd:(BarDidEnd *)instance;
-(void)addUserDidClickPlay:(UserDidClickPlay *)instance;

@end
