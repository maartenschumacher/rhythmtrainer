//
//  ViewController.h
//  openaltest
//
//  Created by Maarten Schumacher on 9/25/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ContainerController.h"

@interface ViewController : UIViewController <ContainerDelegate>

extern NSString * const UserDidClickPlayNotification;
extern NSString * const AppDidEnterBackgroundNotification;
extern NSString * const AppDidBecomeActiveNotification;

@property AVPlayerItem *countInItem;
@property AVPlayer *countInPlayer;

-(void)playCountIn;

@end

