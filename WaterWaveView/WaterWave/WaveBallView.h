//
//  WaveBallView.h
//  WaveBallView
//
//  Created by 酌晨茗 on 16/1/14.
//  Copyright (c) 2016年 酌晨茗. All rights reserved.
//  自定义外观view

#import <UIKit/UIKit.h>

@interface WaveBallView : UIView

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, weak, readonly) UILabel *numberLabel;  // 数值

@property (nonatomic, weak, readonly) UILabel *unitLabel;    // 单位

@property (nonatomic, weak, readonly) UILabel *explainLabel; // 数值含义

@property (nonatomic, strong) UIColor *frontWaveColor;

@property (nonatomic, strong) UIColor *backWaveColor;

@property (nonatomic, assign) CGFloat percent;

@property (nonatomic, assign) UIEdgeInsets waveViewEdge;

- (void)increaseWaveByPercent:(CGFloat)percent;

- (void)decreaseWaveByPercent:(CGFloat)percent;

- (void)startWave;

- (void)stopWave;

- (void)resetWave;

@end
