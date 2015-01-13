//
//  SixteenBeatsBehavior.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeterBehavior.h"

@interface SixteenBeatsBehavior : NSObject <MeterBehavior>

@property NSInteger numberOfBeats;
@property NSString *meterKey;
@property NSString *musicFileName;


@end
