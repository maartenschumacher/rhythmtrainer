//
//  SixteenBeatsController.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "SixteenBeatsController.h"
#import "SixteenBeatsBehavior.h"

@implementation SixteenBeatsController

-(void)viewDidLoad {
    self.meterBehavior = [[SixteenBeatsBehavior alloc]init];
    [super viewDidLoad];
}

@end
