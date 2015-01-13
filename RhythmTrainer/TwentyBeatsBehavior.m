//
//  TwentyBeatsBehavior.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "TwentyBeatsBehavior.h"

@implementation TwentyBeatsBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        _meterKey = @"Twenty";
        _musicFileName = @"???????????";
        _numberOfBeats = 20;
    }
    return self;
}
@end
