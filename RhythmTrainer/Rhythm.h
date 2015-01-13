//
//  Rhythm.h
//  openaltest
//
//  Created by Maarten Schumacher on 10/3/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rhythm : NSObject <NSCoding>

@property NSMutableDictionary *rhythms;

@property NSString *rhythmKey;

-(NSArray *)getRhythmForLevel:(NSInteger)level ForNumberOfBeats:(NSInteger)beats;
-(NSArray *)saveOrLoadComposedRhythm:(NSArray *)composedRhythm AtLevel:(NSInteger)level;
-(void)makeRhythm;

@end
