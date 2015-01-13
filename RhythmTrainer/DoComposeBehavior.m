//
//  DoComposeBehavior.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 05/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "DoComposeBehavior.h"

@implementation DoComposeBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        _composeKey = @"DoCompose";
    }
    return self;
}

/*
 compose mode:
 don't get a correctbeats rhythm
 end of bar checking:
 if levelIteration == 0
 if tagged beats more than three,
 save tagged beats in correctbeats
 then further leveliterations as normal
 
*/

-(NSArray *)getOrSetRhythm:(NSArray *)rhythm AtInstance:(Rhythm *)rhythmInstance ForLevel:(NSInteger)level ForNumberOfBeats:(NSInteger)beats {
    NSArray *returnRhythm = [rhythmInstance saveOrLoadComposedRhythm:rhythm AtLevel:level];
    return returnRhythm;
}

@end
