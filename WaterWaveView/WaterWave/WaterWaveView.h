//
//  WaterWaveView.h
//  WaterWaveView
//
//  Created by 酌晨茗 on 16/1/14.
//  Copyright (c) 2016 酌晨茗. All rights reserved.
//  核心波浪view

#import <UIKit/UIKit.h>

@interface WaterWaveView : UIView

@property (nonatomic, strong) UIColor *frontWaveColor;

@property (nonatomic, strong) UIColor *backWaveColor;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, weak, readonly) UILabel *numberLabel;  // 数值

@property (nonatomic, weak, readonly) UILabel *unitLabel;    // 单位

@property (nonatomic, weak, readonly) UILabel *explainLabel; // 数值含义

@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, assign) UIEdgeInsets waveViewEdge;

- (void)startWave;

- (void)stopWave;

- (void)reset;

@end
