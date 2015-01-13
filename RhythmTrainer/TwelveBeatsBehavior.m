//
//  TwelveBeatsBehavior.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "TwelveBeatsBehavior.h"

@implementation TwelveBeatsBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        _meterKey = @"Twelve";
        _musicFileName = @"appmusic12trimmed";
        _numberOfBeats = 12;
    }
    return self;
}
@end
