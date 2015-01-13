//
//  ContainerController.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 11/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreViewController.h"

@protocol ContainerDelegate

-(void)levelDidChange:(NSInteger)level;
-(void)levelIterationDidChange:(NSInteger)levelIteration;
-(void)playCountIn;

@end

@interface ContainerController : UIViewController

-(void)switchToVCWithMeter:(NSInteger)meterIndex AndCompose:(NSInteger)composeIndex;

@property (nonatomic, weak) id delegate;

@property ScoreViewController *currentVC;

@end
