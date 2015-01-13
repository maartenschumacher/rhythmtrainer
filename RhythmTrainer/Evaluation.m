//
//  Evaluation.m
//  RhythmTrainer
//
//  Created by Maarten Schumacher on 18/12/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "Evaluation.h"

@implementation Evaluation

+(Evaluation *)getInstance {
    static Evaluation *instance = nil;
    @synchronized(self) {
        if (instance == nil) {
            instance = [[Evaluation alloc]init];
        }
    }
    return instance;
}

-(void)updateCurrentStats {
    double sessionAverage = 0.0;
    for (UserDidClickPlay *click in self.userClicks) {
        sessionAverage = sessionAverage + (click.difference * 1.0);
    }
    double totalDifferences = (self.averageDifference * [@(self.numberOfClicks)doubleValue]) + sessionAverage;
    NSInteger totalClicks = self.numberOfClicks + self.userClicks.count;
    double newAverage = totalDifferences / [@(totalClicks) doubleValue];
    self.averageDifference = newAverage;
    self.tooSoonPercentage = [self calculateTooSoonPercentageWithSessionClicks:totalClicks];
    self.hitsPercentage = [self calculateHitPercentageWithSessionClicks:totalClicks];
    self.numberOfClicks = totalClicks;
}

-(double)calculateTooSoonPercentageWithSessionClicks:(NSInteger)clicks {
    NSInteger tooSoons = 0;
    for (UserDidClickPlay *click in self.userClicks) {
        if (click.difference < 0) {
            tooSoons++;
        }
    }
    double oldTooSoons = ([@(self.numberOfClicks)doubleValue] * self.tooSoonPercentage);
    double newTooSoonPercentage = ([@(clicks)doubleValue] + [@(self.numberOfClicks)doubleValue]) / ([@(tooSoons)doubleValue] + oldTooSoons);
    
    return newTooSoonPercentage;
}

-(double)calculateHitPercentageWithSessionClicks:(NSInteger)clicks {
    NSInteger sessionHits = 0;
    for (BarDidEnd *bar in self.barEnds) {
        for (NSNumber *beat in bar.askedRhythm) {
            if (![bar.givenRhythm containsObject:beat]) {
                sessionHits++;
            }
        }
    }
    double oldHits = ([@(self.numberOfClicks)doubleValue] * self.hitsPercentage);
    double newPercentage = ([@(clicks)doubleValue] + [@(self.numberOfClicks)doubleValue]) / ([@(sessionHits)doubleValue] + oldHits);
    return newPercentage;
}

-(NSMutableArray *)checkForAchievements {
    return nil;
}

-(void)saveStatistics {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:self.averageDifference forKey:@"averageDifference"];
    [defaults setDouble:self.tooSoonPercentage forKey:@"tooSoonPercentage"];
    [defaults setInteger:self.hitsPercentage forKey:@"hitsPercentage"];
    [defaults setInteger:self.numberOfClicks forKey:@"numberOfClicks"];
    [defaults synchronize];
}

-(void)loadStatistics {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.averageDifference = [defaults doubleForKey:@"averageDifference"];
    self.tooSoonPercentage = [defaults doubleForKey:@"tooSoonPercentage"];
    self.hitsPercentage = [defaults integerForKey:@"hitsPercentage"];
    self.numberOfClicks = [defaults integerForKey:@"numberOfClicks"];
}

-(void)addUserDidClickPlay:(UserDidClickPlay *)instance {
    [self.userClicks addObject:instance];
}

-(void)addBarDidEnd:(BarDidEnd *)instance {
    [self.barEnds addObject:instance];
}

@end
