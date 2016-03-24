//
//  H7Engine.h
//  ARunning
//
//  Created by Denis Kaibagarov on 3/24/16.
//  Copyright © 2016 sudo.mobi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol H7EngineDelegate <NSObject>

- (void)heartRateChanged:(int)heartRate;

@end

@interface H7Engine : NSObject

@property id<H7EngineDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate;

@end
