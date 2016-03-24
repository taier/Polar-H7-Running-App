//
//  ViewController.m
//  ARunning
//
//  Created by Denis Kaibagarov on 3/24/16.
//  Copyright © 2016 sudo.mobi. All rights reserved.
//

#import "ViewController.h"
#import "H7Engine.h"

@interface ViewController () <H7EngineDelegate>

@property H7Engine* h7Engine;
@property (strong, nonatomic) IBOutlet UILabel *labelCurrentHeartRate;
@property (strong, nonatomic) IBOutlet UILabel *labelRestHeartRate;
@property (strong, nonatomic) IBOutlet UILabel *labelCriticalHeartRate;

@property (assign, nonatomic) int heartRateRest;
@property (assign, nonatomic) int heartRateCritical;

@end

@implementation ViewController


#pragma mark Live Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.h7Engine = [[H7Engine alloc]initWithDelegate:self];
}

#pragma mark Setups

- (void)setupStartAppearance {
    
}

#pragma mark UI Updated

- (void)updateRestHeartRateLabel:(int)newValue {
    self.labelRestHeartRate.text = [NSString stringWithFormat:@"%i",newValue];
}

- (void)updateCriticalHeartRateLabel:(int)newValue {
    self.labelCriticalHeartRate.text = [NSString stringWithFormat:@"%i",newValue];
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

#pragma mark Heart Rate Delegates

- (void)heartRateChanged:(int)heartRate {
    NSLog(@"Heart rate changed %i", heartRate);
    self.labelCurrentHeartRate.hidden = heartRate == 0;
    self.labelCurrentHeartRate.text = [NSString stringWithFormat:@"%i",heartRate];
}


@end
