//
//  BarDidEnd.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 18/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "BarDidEnd.h"
#import "Evaluation.h"

@implementation BarDidEnd

- (instancetype)initWithTimeStamp:(NSDate *)currentTime WithAskedRhythm:(NSArray *)array WithInputtedRhythm:(NSArray *)inputArray WithIteration:(NSInteger)iteration
{
    self = [super init];
    if (self) {
        _timeStamp = currentTime;
        _askedRhythm = array;
        _givenRhythm = inputArray;
        _currentIteration = iteration;
    }
    return self;
}

@end
