//
//  ScoreViewController.m
//  openaltest
//
//  Created by Maarten Schumacher on 10/2/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "ScoreViewController.h"
#import "ViewController.h"
#import "Rhythm.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioSamplePlayer.h"
#import "DoComposeBehavior.h"
#import "NoComposeBehavior.h"
#import "ContainerController.h"
#import "BarDidEnd.h"
#import "UserDidClickPlay.h"
#import "Evaluation.h"

@interface ScoreViewController ()

@property NSInteger numberOfBeats;
@property NSString *rhythmKey;

@property UIImageView *pointerView;
@property UIImageView *upBeatPointer;
@property CGPoint destinationCenter;
@property AVAudioPlayer *player;
@property double pointerFade;

@property BOOL didDrawBeats;

@end

@implementation ScoreViewController {
    Evaluation *evaluationInstance;
    CGPoint pointerCenter;
    CGPoint upBeatPointerCenter;
    ContainerController *parentVC;
    NSMutableArray *allBeats;
    CGPoint upBeatDestinationCenter;
    NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    evaluationInstance = [Evaluation getInstance];
    self.numberOfBeats = [self.meterBehavior numberOfBeats];
    self.rhythmKey = [[self.meterBehavior meterKey] stringByAppendingString:[self.composeBehavior composeKey]];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(saveUserData:)
                                                name:AppDidEnterBackgroundNotification
                                              object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(loadUserData:)
//                                                name:AppDidBecomeActiveNotification
//                                              object:nil];
    }

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.didDrawBeats == NO) {
        [self drawBeatsAndPointers];
        self.didDrawBeats = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    self.pointerView.alpha = 0.0;
    self.upBeatPointer.alpha = 0.0;
    self.pointerFade = 1.0;
    NSString *path = [self getFilePathForRhythm];
    [self createAndArchiveRhythmAt:path];
    [self unarchiveRhythmAt:path];
    parentVC = (ContainerController *)self.parentViewController;
    AVPlayerItem *item = [parentVC.delegate countInItem];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(startBackgroundMusic:)
                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                              object:item];

    [self addObserver:parentVC.delegate
           forKeyPath:@"currentLevel"
              options:NSKeyValueObservingOptionNew
              context:nil];
    [self addObserver:parentVC.delegate
           forKeyPath:@"currentLevelIteration"
              options:NSKeyValueObservingOptionNew
              context:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(startBackgroundMusic:)
                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                              object:[parentVC.delegate countInItem]];
    self.correctBeats = [[NSMutableArray alloc]init];
    [self loadUserData:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self saveUserData:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    parentVC = nil;
    }

-(void)loadUserData:(NSNotification *)notification {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger level = [standardUserDefaults integerForKey:self.rhythmKey];
    self.currentLevel = level;
    [self changeLevel];
}

-(void)saveUserData:(NSNotification *)notification {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:self.currentLevel forKey:self.rhythmKey];
    [standardUserDefaults synchronize];
    
    [NSKeyedArchiver archiveRootObject:self.rhythmInstance toFile:[self getFilePathForRhythm]];
    
    [self.player stop];
    self.player = nil;
    [timer invalidate];
    
    [self.pointerView.layer removeAllAnimations];
    [self.upBeatPointer.layer removeAllAnimations];
}

-(NSString *)getFilePathForRhythm {
    NSURL *documentDir = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory
                                                               inDomain:NSUserDomainMask
                                                      appropriateForURL:nil create:NO error:nil];
    NSURL *plist = [documentDir URLByAppendingPathComponent:@"rhythmsnew.plist"];
    return plist.path;
}

-(void)createAndArchiveRhythmAt:(NSString *)filePath {
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        Rhythm *rhythm = [[Rhythm alloc]init];
        [rhythm makeRhythm];
        [NSKeyedArchiver archiveRootObject:rhythm toFile:filePath];
    }
}

-(void)unarchiveRhythmAt:(NSString *)filePath {
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        Rhythm *rhythm = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        rhythm.rhythmKey = self.rhythmKey;
        self.rhythmInstance = rhythm;
    } else {
        NSLog(@"error: plist file not found");
    }
    
}

-(void)startBackgroundMusic:(NSNotification *)notification {
    NSString *path = [[NSBundle mainBundle]pathForResource:[self.meterBehavior musicFileName] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [self.player setNumberOfLoops:-1];
    [self.player prepareToPlay];
    
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:4
                                             target:self
                                           selector:@selector(updateTime:)
                                           userInfo:nil
                                            repeats:YES];
    [self.player play];
    [self animatePointer];
}

-(void)updateTime: (NSTimer *)aTimer {
    [self resetBeatStates];
    [self checkInput];
}

-(NSInteger)getClickTime {
    double clickedTime = [self.player currentTime];
    //round clickedtime to nearest 16th
    double barClickedTime = fmod(clickedTime, 4.0);
    barClickedTime = (barClickedTime / (1.0 / ([@(self.numberOfBeats)doubleValue] / 4.0)));
    double roundedClickedTime = round(barClickedTime);
    double difference = barClickedTime - roundedClickedTime;
    NSInteger num = (NSInteger)roundedClickedTime;
    if (num == self.numberOfBeats) {
        num = 0;
    }
    [[AudioSamplePlayer getInstance] userDidClickPlayAt:num WithMeter:self.numberOfBeats];
    
    NSDate *currentTime = [[NSDate alloc]init];
    UserDidClickPlay *clickInstance = [[UserDidClickPlay alloc]initWithTimeStamp:currentTime WithDifference:difference];
    [evaluationInstance addUserDidClickPlay:clickInstance];
    if (![self.correctBeats containsObject:@(num)]) {
        if ((difference > -0.25) && (difference < 0.25)) {
            [self.correctBeats addObject:@(num)];
            return num;
        } else {
            return 100;
        }
    }
    else {
        if ((difference > -0.125) && (difference < 0.25)) {
            [self.correctBeats removeObject:@(num)];
            return num;
        } else {
            return 100;
        }
    }
}

-(void)userDidClickPlay {
    NSInteger clickTime = [self getClickTime];
    if (clickTime < self.numberOfBeats) {
        [self highlightBeat:clickTime];
    }
    else {
        [self.correctBeats addObject:@(clickTime)];
    }
    
}


-(void)resetBeatStates {
    for (UIImageView *beat in allBeats) {
        beat.image = [UIImage imageNamed:@"smalldot"];
    }
}

-(void)changeLevel {
    [self cleanScore];
    //get new rhythm
    self.currentRhythm = [self.composeBehavior getOrSetRhythm:self.correctBeats AtInstance:self.rhythmInstance ForLevel:self.currentLevel ForNumberOfBeats:self.numberOfBeats];
    if (self.currentRhythm) {
        self.correctBeats = [self.currentRhythm mutableCopy];
    };
    self.currentLevelIteration = 0;
    [self configureScore];
    //update level display
    [self updatePointerAnimation];
}

-(void)updatePointerAnimation {
    if (self.currentLevel > 6) {
        [self.pointerView setHidden:YES];
        [self.upBeatPointer setHidden:YES];
    }
    else {
        [self.pointerView setHidden:NO];
        [self.upBeatPointer setHidden:NO];
        self.pointerFade = 1.0 - ((double)self.currentLevel * 0.125);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cleanScore {
    for (int i=0; i < allBeats.count; i++) {
        if ([self.currentRhythm containsObject:@(i)]) {
            UIImageView *beat = allBeats[i];
            double duration = 0.2;
            double beatDelay = (duration / (double)allBeats.count) * i;
            [self animateBeat:beat withDuration:duration withDelay:beatDelay withScale:1.0];
        }
    }
}

-(void)configureScore {
    double i = 0.0;
    for (NSNumber *beatNumber in self.currentRhythm) {
        UIImageView *beat = allBeats[[beatNumber integerValue]];
        double duration = 1.0;
        double beatDelay = (double)((duration / (double)self.currentRhythm.count) * i) + 1.0;
        [self animateBeat:beat withDuration:duration withDelay:beatDelay withScale:1.8];
        i = i + 1.0;
    }
}

-(void)checkLevelIteration {
    self.currentLevelIteration++;
    if (self.currentLevelIteration == 3) {
        [[AudioSamplePlayer getInstance] playAudioSample:@"applause" withPitch:0.5];
        self.currentLevel++;
        [self changeLevel];
    }
}

-(void)checkInput {
    NSDate *currentTime = [[NSDate alloc]init];
    BarDidEnd *barInstance = [[BarDidEnd alloc]initWithTimeStamp:currentTime WithAskedRhythm:self.currentRhythm WithInputtedRhythm:self.correctBeats WithIteration:self.currentLevelIteration];
    [evaluationInstance addBarDidEnd:barInstance];
    if (self.correctBeats.count == 0) {
        [self checkLevelIteration];
    }
    else {
        if (self.currentLevelIteration > 0) {
            self.currentLevelIteration -= 1;
        }
    }
    self.correctBeats = [self.currentRhythm mutableCopy];
}


-(void)highlightBeat:(NSInteger)clickedBeat {
    NSNumber *beatnumber = [NSNumber numberWithInteger:clickedBeat];
    UIImageView *beat = allBeats[clickedBeat];
    if ([self.currentRhythm containsObject:beatnumber]) {
        beat.image = [UIImage imageNamed:@"smalldotgreen"];
    }
    else {
        if ([self.composeBehavior isMemberOfClass:[DoComposeBehavior class]] && (self.currentLevelIteration == 0)) {
            [self animateBeat:beat withDuration:1.0 withDelay:0.0 withScale:1.8];
        }
        else {
            beat.image = [UIImage imageNamed:@"smalldotred"];
        }
    }
}

-(void)drawBeatsAndPointers {
    allBeats = [[NSMutableArray alloc]init];
    
    NSInteger padding = 40;
    NSInteger totalWidth = self.view.frame.size.width - (2*padding);
    NSInteger numberOfGroups = 4;
    NSInteger numberOfBeats = self.numberOfBeats;
    NSInteger numberOfBarlines = numberOfGroups - 1;
    NSInteger numberOfBeatPaddings = ((numberOfBeats + numberOfBarlines) - 1);
    NSInteger beatWidth = 20;
    NSInteger barlineWidth = 4;
    NSInteger totalElementsWidth = (beatWidth * numberOfBeats) + (barlineWidth * numberOfBarlines);
    NSInteger beatPadding = (totalWidth - totalElementsWidth) / numberOfBeatPaddings;
    
    if (beatPadding > 10) {
        padding = padding + (((beatPadding - 10) * numberOfBeatPaddings) / 2);
        totalWidth = self.view.frame.size.width - (2*padding);
        beatPadding = 10;
    }
    NSInteger groupWidth = totalWidth / numberOfGroups;
    
    
    for (int i = 0; i < numberOfGroups; i++) {
        NSInteger xorigin = padding + (i*groupWidth);
        for (int j = 0; j < (numberOfBeats / numberOfGroups); j++) {
            CGFloat xpoint = xorigin + (j * (beatWidth + beatPadding));
            CGRect frame = CGRectMake(xpoint, 10, beatWidth, 50);
            UIImageView *beat = [[UIImageView alloc]initWithFrame:frame];
            [beat setContentMode:UIViewContentModeCenter];
            beat.image = [UIImage imageNamed:@"smalldot"];
            [self.view addSubview:beat];
            [allBeats addObject:beat];
        }
        if (i < numberOfBarlines) {
            CGFloat xpoint = xorigin + ((numberOfBeats / numberOfGroups) * (beatWidth + beatPadding));
            CGRect frame = CGRectMake(xpoint, 10, barlineWidth, 50);
            UIImageView *barline = [[UIImageView alloc]initWithFrame:frame];
            barline.image = [UIImage imageNamed:@"barline"];
            [self.view addSubview:barline];
        }
    }
    
    UIImageView *firstbeat = allBeats[0];
    CGRect frame = CGRectMake(0, 0, 30, 30);
    UIImageView *pointerView = [[UIImageView alloc] initWithFrame:frame];
    pointerCenter = CGPointMake(firstbeat.center.x, (firstbeat.center.y + 40));
    pointerView.center = pointerCenter;
    pointerView.image = [UIImage imageNamed:@"pointer"];
    [self.view addSubview:pointerView];
    upBeatDestinationCenter = pointerView.center;
    self.pointerView = pointerView;
    
    CGRect upBeatFrame = CGRectMake(0, 0, 30, 30);
    UIImageView *upBeatPointer = [[UIImageView alloc]initWithFrame:upBeatFrame];
    upBeatPointerCenter = CGPointMake((firstbeat.center.x - groupWidth), (firstbeat.center.y + 40));
    upBeatPointer.center = upBeatPointerCenter;
    upBeatPointer.image = [UIImage imageNamed:@"pointer"];
    upBeatPointer.alpha = 0.0;
    [self.view addSubview:upBeatPointer];
    self.upBeatPointer = upBeatPointer;
    
    UIImageView *lastbeat = allBeats[(numberOfBeats - 1)];
    self.destinationCenter = CGPointMake((padding + (groupWidth * numberOfGroups) + (beatWidth / 2)), lastbeat.center.y + 40);
}

-(void)animatePointer {
    self.pointerView.center = pointerCenter;
    self.upBeatPointer.center = upBeatPointerCenter;
    self.pointerView.alpha = 1.0;
    self.upBeatPointer.alpha = 0.0;
    
    [UIView animateKeyframesWithDuration:4
                                   delay:0
                                 options:(UIViewKeyframeAnimationOptionRepeat | UIViewAnimationOptionCurveLinear)
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:1.0
                                                                animations:^{
                                                                    self.pointerView.center = self.destinationCenter;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.75
                                                          relativeDuration:0.25
                                                                animations:^{
                                                                    self.upBeatPointer.center = upBeatDestinationCenter;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:self.pointerFade
                                                                animations:^{
                                                                    self.pointerView.alpha = 0.0;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.875
                                                          relativeDuration:0.125
                                                                animations:^{
                                                                    self.upBeatPointer.alpha = 1.0;
                                                                }];
                              }
                              completion:NULL];
}

-(void)animateBeat:(UIImageView *) beat withDuration:(double)duration withDelay: (double) delay withScale:(double)scale{
    [UIView animateWithDuration:1.0
                          delay:delay
                        options:0
                     animations:^{
                         beat.transform =CGAffineTransformMakeScale(scale,scale);
                     }completion:NULL];
}

@end
