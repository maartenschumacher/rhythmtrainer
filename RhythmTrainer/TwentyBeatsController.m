//
//  TwentyBeatsController.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "TwentyBeatsController.h"
#import "TwentyBeatsBehavior.h"

@implementation TwentyBeatsController

-(void)viewDidLoad {
    self.meterBehavior = [[TwentyBeatsBehavior alloc]init];
    [super viewDidLoad];
}

@end
