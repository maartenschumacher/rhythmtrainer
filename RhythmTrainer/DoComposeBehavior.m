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

-(NSArray *)getOrSetRhythm:(NSArray *)rhythm AtInstance:(Rhythm *)rhythmInstance ForLevel:(NSInteger)level ForNumberOfBeats:(NSInteger)beats {
    NSArray *returnRhythm = [rhythmInstance saveOrLoadComposedRhythm:rhythm AtLevel:level];
    return returnRhythm;
}

@end
