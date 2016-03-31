//
//  ViewController.m
//  ARunning
//
//  Created by Denis Kaibagarov on 3/24/16.
//  Copyright © 2016 sudo.mobi. All rights reserved.
//

#import "ViewController.h"
#import "H7Engine.h"
#import "Follower.h"

// For sound
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <H7EngineDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FollowerDelegate>

@property H7Engine* h7Engine;
@property (strong, nonatomic) IBOutlet UILabel *labelCurrentHeartRate;
@property (strong, nonatomic) IBOutlet UILabel *labelRestHeartRate;
@property (strong, nonatomic) IBOutlet UILabel *labelCriticalHeartRate;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance;

@property (strong, nonatomic) IBOutlet UIPickerView *pickerRest;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerRun;

@property (assign, nonatomic) int heartRateRest;
@property (assign, nonatomic) int heartRateCritical;

@property (assign, nonatomic) bool inZoneRest;
@property (assign, nonatomic) bool inZoneCritical;

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) Follower *follower;

@property (strong, nonatomic) NSMutableArray *pickerDataArray;

@end

@implementation ViewController


#pragma mark Live Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.h7Engine = [[H7Engine alloc]initWithDelegate:self];
    [self setupPickerDataArray];
    [self setupStartAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark Setups

- (void)setupStartAppearance {
    [self.pickerRest selectRow:1 inComponent:0 animated:false];
    [self.pickerRun selectRow:7 inComponent:0 animated:false];
}

- (void)setupPickerDataArray {
    self.pickerDataArray = [NSMutableArray new];
    [self.pickerDataArray addObject:@100];
    [self.pickerDataArray addObject:@200];
    [self.pickerDataArray addObject:@300];
    [self.pickerDataArray addObject:@400];
    [self.pickerDataArray addObject:@500];
    [self.pickerDataArray addObject:@600];
    [self.pickerDataArray addObject:@700];
    [self.pickerDataArray addObject:@800];
    [self.pickerDataArray addObject:@900];
    [self.pickerDataArray addObject:@1000];
}

#pragma mark UI Updated

- (void)updateRestHeartRateLabel:(int)newValue {
    self.labelRestHeartRate.text = [NSString stringWithFormat:@"%i",newValue];
}

- (void)updateCriticalHeartRateLabel:(int)newValue {
    self.labelCriticalHeartRate.text = [NSString stringWithFormat:@"%i",newValue];
}

#pragma mark Engine

- (void)checkIfEnterZonesWithHeartRate:(int)heartRate {
    if(heartRate <= self.heartRateRest &&  !self.inZoneRest) {
        [self playSound];
        self.inZoneRest = true;
    } else if (heartRate > self.heartRateRest) {
         self.inZoneRest = false;
    }
    
    if(heartRate >= self.heartRateCritical &&  !self.inZoneCritical) {
        [self playSound];
        self.inZoneCritical = true;
    } else if (heartRate < self.heartRateCritical) {
        self.inZoneCritical = false;
    }
}

- (void)playSound {
    
    if(!self.player) {
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"beep"                                              ofType:@"wav"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL                                                           error:nil];
        self.player.numberOfLoops = 1;
    }
    
    [self.player play];
}

#pragma mark Actions

- (IBAction)stepperValueChange:(UIStepper *)sender {
    if (sender.tag == 1) {
        [self updateRestHeartRateLabel:sender.value];
        self.heartRateRest = sender.value;
    }
    
    if (sender.tag == 2) {
        [self updateCriticalHeartRateLabel:sender.value];
        self.heartRateCritical = sender.value;
    }
}

- (IBAction)onStartButtonPress:(id)sender {
    
    if (!self.follower) {
        self.follower = [Follower new];
        self.follower.delegate = self;
    }
    
    if(self.follower.trackingState != TrackingStateTracking) {
        [self.follower beginRouteTracking];
    }
    
}

#pragma mark Follower delegates

- (void)followerDidUpdate:(Follower *)follower {
    CLLocationDistance distance = [self.follower totalDistanceWithUnit:DistanceUnitMeters];
    NSString *distanceString = [[NSString alloc] initWithFormat: @"%f", distance];
    self.labelDistance.text = distanceString;
}

#pragma mark Heart Rate Delegates

- (void)heartRateChanged:(int)heartRate {
    NSLog(@"Heart rate changed %i", heartRate);
    
    if(heartRate == 0) {
        self.labelCurrentHeartRate.hidden = true;
        return;
    }
    
    [self checkIfEnterZonesWithHeartRate:heartRate];
    self.labelCurrentHeartRate.text = [NSString stringWithFormat:@"%i",heartRate];
}

#pragma mark Picker Delegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return  1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerDataArray.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%li", (long)[self.pickerDataArray[row] integerValue]];
}




@end
