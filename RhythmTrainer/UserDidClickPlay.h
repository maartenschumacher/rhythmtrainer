//
//  UserDidClickPlay.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 18/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDidClickPlay : NSObject

@property NSDate *timeStamp;
@property double difference;

- (instancetype)initWithTimeStamp:(NSDate *)timeStamp WithDifference:(double)difference;

@end
