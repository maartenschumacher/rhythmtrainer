//
//  ViewController.m
//  openaltest
//
//  Created by Maarten Schumacher on 9/25/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioSamplePlayer.h"
#import "Rhythm.h"
#import "SixteenBeatsController.h"
#import "TwelveBeatsController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;
@property (weak, nonatomic) IBOutlet UIStepper *levelStepper;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *countInLabel;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UISegmentedControl *meterControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *composeControl;

@end

@implementation ViewController {
    ContainerController *containerController;
    id returnObject;
    void (^countInBlock)(CMTime time);
}

NSString * const AppDidEnterBackgroundNotification = @"AppDidEnterBackgroundNotification";
NSString * const AppDidBecomeActiveNotification = @"AppDidBecomeActiveNotification";

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"score_embed"]) {
        containerController = [segue destinationViewController];
        containerController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_async(dispatch_queue_create("audiosampleplayerqueue", 0), ^{
        AudioSamplePlayer *samplePlayerInstance = [AudioSamplePlayer getInstance];
        [samplePlayerInstance preLoadAudioSample:@"sinesample4"];
        [samplePlayerInstance preLoadAudioSample:@"applause"];
    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(loadCountIn:)
                                                name:AppDidBecomeActiveNotification
                                              object:nil];
    
    self.resultLabel.text = @"Iteration 0";
    self.chapterNameLabel.text = @"Level 0-4: Baby steps";
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentLevel"]) {
        [self levelDidChange:[[object valueForKeyPath:keyPath]integerValue]];
    }
    if ([keyPath isEqualToString:@"currentLevelIteration"]) {
        [self levelIterationDidChange:[[object valueForKeyPath:keyPath]integerValue]];
    }
    if (object == self.countInPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.countInPlayer.status == AVPlayerItemStatusReadyToPlay) {
            CMTime interval = CMTimeMake(1, 2);
            returnObject = [self.countInPlayer addPeriodicTimeObserverForInterval:interval
                                                                            queue:NULL
                                                                       usingBlock:countInBlock];
            dispatch_async(dispatch_queue_create("myqueue", 0), ^{
                [self.countInPlayer play];
                [self.countInPlayer removeObserver:self forKeyPath:@"status"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.countInPlayer removeTimeObserver:returnObject];
                });
            });
        }
        if (self.countInPlayer.status == AVPlayerItemStatusFailed) {
            NSLog(@"error");
        }
    }
    
}

-(void)loadCountIn:(NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    countInBlock = ^(CMTime time){
        NSArray *values = @[@4,@4,@3,@3,@4,@3,@2,@1,@""];
        static int i = 0;
        weakSelf.countInLabel.text = [NSString stringWithFormat:@"%@",values[i]];
        i++;
    };
    NSString *path = [[NSBundle mainBundle]pathForResource:@"4:4 count-in" ofType:@"aiff"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVAsset *asset = [AVAsset assetWithURL:url];
    self.countInItem = [AVPlayerItem playerItemWithAsset:asset];
    self.countInPlayer = [AVPlayer playerWithPlayerItem:self.countInItem];
    [self.countInPlayer addObserver:self
                    forKeyPath:@"status"
                       options:0
                       context:nil];
    
}

-(void)playCountIn {
    [self.countInPlayer seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finished){
        [self.countInPlayer play];
    }];
}

-(void)levelDidChange:(NSInteger)level {
    self.levelLabel.text = [NSString stringWithFormat:@"Level %li",((long)level + 1)];
    self.levelStepper.value = level;
}

-(void)levelIterationDidChange:(NSInteger)levelIteration {
    self.resultLabel.text = [NSString stringWithFormat:@"Iteration %li", (long)levelIteration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    [containerController.currentVC userDidClickPlay];
}

- (IBAction)MeterControl:(id)sender {
    [containerController switchToVCWithMeter:[self.meterControl selectedSegmentIndex] AndCompose:[self.composeControl selectedSegmentIndex]];
}

- (IBAction)composeControl:(id)sender {
    [containerController switchToVCWithMeter:[self.meterControl selectedSegmentIndex] AndCompose:[self.composeControl selectedSegmentIndex]];
}

- (IBAction)stepperAction:(id)sender {
    [containerController.currentVC setCurrentLevel:self.levelStepper.value];
    [containerController.currentVC changeLevel];
}

@end
