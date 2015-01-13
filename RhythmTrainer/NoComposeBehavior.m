//
//  NoComposeBehavior.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 05/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "NoComposeBehavior.h"

@implementation NoComposeBehavior

- (instancetype)init
{
    self = [super init];
    if (self) {
        _composeKey = @"NoCompose";
    }
    return self;
}

-(NSArray *)getOrSetRhythm:(NSArray *)rhythm AtInstance:(Rhythm *)rhythmInstance ForLevel:(NSInteger)level ForNumberOfBeats:(NSInteger)beats {
    return [rhythmInstance getRhythmForLevel:level ForNumberOfBeats:beats];
}

@end
