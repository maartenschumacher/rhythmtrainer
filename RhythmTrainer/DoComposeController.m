//
//  DoComposeController.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 15/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "DoComposeController.h"

@implementation DoComposeController

-(void)checkInput {
        if ((self.currentLevelIteration == 0) && (self.correctBeats.count >= 3)) {
        [self changeLevel];
        [self checkLevelIteration];
    }
    if ((self.correctBeats.count == 0) && (self.currentLevelIteration > 0)) {
        [self checkLevelIteration];
    }
    else {
        if (self.currentLevelIteration > 0) {
            self.currentLevelIteration -= 1;
        }
    }
    self.correctBeats = [self.currentRhythm mutableCopy];
}


@end
