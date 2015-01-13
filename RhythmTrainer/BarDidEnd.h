//
//  BarDidEnd.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 18/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarDidEnd : NSObject

@property NSDate *timeStamp;
@property NSArray *askedRhythm;
@property NSArray *givenRhythm;
@property NSInteger currentIteration;

- (instancetype)initWithTimeStamp:(NSDate *)currentTime WithAskedRhythm:(NSArray *)array WithInputtedRhythm:(NSArray *)inputArray WithIteration:(NSInteger)iteration;

@end
