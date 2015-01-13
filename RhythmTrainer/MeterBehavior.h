//
//  MeterBehavior.h
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 04/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MeterBehavior <NSObject>

@required

@property NSInteger numberOfBeats;
@property NSString *meterKey;
@property NSString *musicFileName;


@end
