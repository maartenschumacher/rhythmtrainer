//
//  Rhythm.m
//  openaltest
//
//  Created by Maarten Schumacher on 10/3/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "Rhythm.h"
#import "ViewController.h"

@implementation Rhythm {
    NSArray *sixteennocompose;
    NSArray *twelvenocompose;
    NSArray *twentynocompose;
}

//create and update rhythms plist file

-(void)makeRhythm {
    //fill rhythms
    sixteennocompose = @[
                         @[@0,@2,@4,@6,@8,@10,@12,@14],
                         @[@0,@4,@8,@12],
                         @[@0,@2,@4,@8,@10,@12],
                         @[@0,@8],
                         @[@0,@4,@6,@8,@12,@14],
                         @[@0,@2,@4,@8,@10,@12],
                         @[@2,@4,@6,@8,@12],
                         @[@4,@8,@10,@12],
                         @[@6,@8,@10,@12,@14],
                         @[@8,@10,@14],
                         @[@2,@4,@8,@10,@14],
                         @[@0,@3,@4,@7,@8,@11,@12],
                         @[@0,@2,@3,@4,@8,@10,@11,@12],
                         @[@0,@1,@3,@4,@6,@8,@10,@11,@12],
                         @[@0,@3,@4,@5,@8,@9,@10,@12,@15],
                         @[@0,@1,@2,@3,@4,@6,@8,@10,@11,@12,@13],
                         @[@4,@12],
                         @[@2,@6,@10,@14],
                         @[@1,@3,@4,@6,@9,@11,@12,@14],
                         @[@1,@2,@4,@11,@12,@14],
                         @[@1,@3,@5,@7,@9,@11,@13,@15],
                         @[@0,@3,@6,@9,@12,@14],
                         @[@0,@2,@5,@8,@11,@14],
                         @[@1,@4,@7,@10,@12,@13],
                         @[@0,@1,@3,@4,@6,@7,@9,@10,@12,@13,@14],
                         @[@0,@1,@2,@6,@7,@8,@12,@13,@14]
                         ];
    twelvenocompose = @[
                        @[@0,@3,@6,@9],
                        @[@0,@2,@3,@5,@6,@8,@9,@11]
                        ];
    twentynocompose = @[
                        @[@0,@5,@10,@15],
                        @[@0,@3,@5,@8,@10,@13,@15]
                        ];
    
    self.rhythms = [@{
                     @"SixteenNoCompose" : [sixteennocompose mutableCopy],
                     @"TwelveNoCompose" : [twelvenocompose mutableCopy],
                     @"TwentyNoCompose" : [twentynocompose mutableCopy],
                     } mutableCopy];
    
}


-(NSMutableArray *)generateRandomRhythmForNumberOfBeats:(NSInteger)beats {
    int numberOfRolls = arc4random_uniform(6) + 3;
    NSMutableArray *rhythm = [[NSMutableArray alloc]init];
    
    for (int i=0; i < numberOfRolls; i++) {
        NSNumber *roll;
        do {
            roll = [NSNumber numberWithInt:arc4random_uniform((int)beats)];
        } while ([rhythm containsObject:roll]);
        [rhythm addObject:roll];
    }
    
    return rhythm;
}

-(NSArray *)saveOrLoadComposedRhythm:(NSArray *)composedRhythm AtLevel:(NSInteger)level {
    NSMutableArray *rhythm = [self.rhythms objectForKey:self.rhythmKey];
    if (!rhythm) {
        rhythm = [[NSMutableArray alloc]init];
        [self.rhythms setObject:rhythm forKey:self.rhythmKey];
    }
    if (level >= rhythm.count) {
        if (composedRhythm) {
            [rhythm addObject:composedRhythm];
            return composedRhythm;
        }
        else {
            return nil;
        }
        
    }
    return rhythm[level];
}

-(NSArray *)getRhythmForLevel:(NSInteger)level ForNumberOfBeats:(NSInteger)beats {
    NSMutableArray *rhythm = [self.rhythms objectForKey:self.rhythmKey];
    if (!rhythm) {
        rhythm = [[NSMutableArray alloc]init];
        [self.rhythms setObject:rhythm forKey:self.rhythmKey];
    }
    if (level >= rhythm.count) {
        [rhythm addObject:[self generateRandomRhythmForNumberOfBeats:beats]];
    }
    return rhythm[level];
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.rhythms forKey:@"rhythms"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _rhythms = [[aDecoder decodeObjectForKey:@"rhythms"] mutableCopy];
    }
    return self;
}

@end
