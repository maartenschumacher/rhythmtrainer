//
//  SixteenBeatsBehavior.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "SixteenBeatsBehavior.h"

@implementation SixteenBeatsBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        _meterKey = @"Sixteen";
        _musicFileName = @"apphiphopbackgroundnew";
        _numberOfBeats = 16;
    }
    return self;
}

@end
