//
//  UserDidClickPlay.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 18/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "UserDidClickPlay.h"
#import "Evaluation.h"

@implementation UserDidClickPlay

- (instancetype)initWithTimeStamp:(NSDate *)timeStamp WithDifference:(double)difference
{
    self = [super init];
    if (self) {
        _timeStamp = timeStamp;
        _difference = difference;
    }
    return self;
}

@end
