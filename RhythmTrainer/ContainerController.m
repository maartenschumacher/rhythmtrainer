//
//  ContainerController.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 11/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "ContainerController.h"
#import "SixteenBeatsBehavior.h"
#import "TwelveBeatsBehavior.h"
#import "NoComposeBehavior.h"
#import "DoComposeBehavior.h"
#import "ScoreViewController.h"
#import "DoComposeController.h"

@interface ContainerController ()

@property NSMutableArray *instances;

@end

@implementation ContainerController

-(void)viewDidLoad {
    self.instances = [[NSMutableArray alloc]init];
    for (int i = 0; i<12; i++) {
        [self.instances addObject:@(i)];
    }
    ScoreViewController *newVC = [self instantiateVCWithMeter:0 AndCompose:0];
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.currentVC = newVC;
}

-(void)switchToVCWithMeter:(NSInteger)meterIndex AndCompose:(NSInteger)composeIndex {
    ScoreViewController *newVC = [self instantiateVCWithMeter:meterIndex AndCompose:composeIndex];
    [self moveToNewController:newVC];
}

-(ScoreViewController *)instantiateVCWithMeter:(NSInteger)meterIndex AndCompose:(NSInteger)composeIndex {
    NSInteger index = meterIndex * 2 + composeIndex;
    id variable = self.instances[index];
    if ([variable isKindOfClass:[NSNumber class]]) {
        ScoreViewController *newVC = [[ScoreViewController alloc]init];
        if (meterIndex == 0) {
            newVC.meterBehavior = [[SixteenBeatsBehavior alloc]init];
        }
        if (meterIndex == 1) {
            newVC.meterBehavior = [[TwelveBeatsBehavior alloc]init];
        }
        if (composeIndex == 0) {
            newVC.composeBehavior = [[NoComposeBehavior alloc]init];
        }
        if (composeIndex == 1) {
            newVC = (DoComposeController *)newVC;
            newVC.composeBehavior = [[DoComposeBehavior alloc]init];
        }
        [self.instances replaceObjectAtIndex:index withObject:newVC];
    }
    ScoreViewController *targetVC = self.instances[index];
    [self addChildViewController:targetVC];
    targetVC.view.frame = self.view.bounds;
    return targetVC;
}

-(void)moveToNewController:(ScoreViewController *) newController {
    [self.currentVC willMoveToParentViewController:nil];
    [self transitionFromViewController:self.currentVC toViewController:newController duration:.6 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil
                            completion:^(BOOL finished) {
                                [self.currentVC removeFromParentViewController];
                                [newController didMoveToParentViewController:self];
                                self.currentVC = newController;
                                [self.delegate playCountIn];
                            }];
}

@end
