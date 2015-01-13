//
//  ComposeBehavior.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rhythm.h"

@protocol ComposeBehavior <NSObject>

@required

@property NSString *composeKey;

-(NSArray *)getOrSetRhythm:(NSArray *)rhythm AtInstance:(Rhythm *)rhythmInstance ForLevel:(NSInteger)level ForNumberOfBeats:(NSInteger)beats;

@end
