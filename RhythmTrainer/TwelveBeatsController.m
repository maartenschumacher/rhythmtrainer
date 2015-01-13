//
//  TwelveBeatsController.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "TwelveBeatsController.h"
#import "TwelveBeatsBehavior.h"

@implementation TwelveBeatsController

-(void)viewDidLoad {
    self.meterBehavior = [[TwelveBeatsBehavior alloc]init];
    [super viewDidLoad];
}

@end
