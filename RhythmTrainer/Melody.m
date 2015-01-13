//
//  Melody.m
//  openaltest
//
//  Created by Maarten Schumacher on 10/3/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "Melody.h"
#import "ViewController.h"

@interface Melody ()

@property NSMutableArray *melody;

@end

@implementation Melody

static NSDictionary *scale;
static NSArray *melodynotes;

- (instancetype)init
{
    self = [super init];
    if (self) {
        scale = @{@"e":@659.25f, @"d":@587.33f, @"c":@523.25f, @"a":@440.00f, @"g":@392.00f};
        melodynotes = [[NSArray alloc]initWithArray:[scale allKeys]];
        
    }
    return self;
}

-(NSMutableArray *)generateRandomMelodyWithMeter:(NSInteger)meter {
    NSMutableArray *melody = [[NSMutableArray alloc]init];
    for (int i=0; i < meter; i++) {
        int random;
        int lastRoll;
        
        do {
            int roll = arc4random_uniform((int)[melodynotes count]);
            random = roll;
        } while (random == lastRoll);
        
        [melody addObject:melodynotes[random]];
        lastRoll = random;
    }
    return melody;
}

-(float)getPitchForTime:(NSInteger)clickedTime WithMeter:(NSInteger)meter {
    if ((self.melody == nil) || (self.melody.count != meter)) {
        NSMutableArray *melody = [self generateRandomMelodyWithMeter:meter];
        self.melody = melody;
    }
    NSString *note = self.melody[clickedTime];
    float pitch = [[scale valueForKey:note]floatValue];
    pitch = pitch / [[scale valueForKey:@"e"]floatValue];
    
    return pitch;
}

@end
