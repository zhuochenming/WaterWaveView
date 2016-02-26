//
//  WaveBallView.m
//  WaveBallView
//
//  Created by 酌晨茗 on 16/1/14.
//  Copyright (c) 2016年 酌晨茗. All rights reserved.
//

#import "WaveBallView.h"
#import "WaterWaveView.h"

@interface WaveBallView ()

@property (nonatomic, weak) WaterWaveView *waterWaveView;

@end

@implementation WaveBallView

#pragma mark - 初始化
- (void)initWithSubView {
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    WaterWaveView *waterWaveView = [[WaterWaveView alloc] init];
    [self addSubview:waterWaveView];
    _waterWaveView = waterWaveView;
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.font = [UIFont systemFontOfSize:50];
    [self addSubview:numberLabel];
    _numberLabel = numberLabel;
    
    UILabel *unitLabel = [[UILabel alloc] init];
    [self addSubview:unitLabel];
    _unitLabel = unitLabel;
    
    UILabel *explainLabel = [[UILabel alloc] init];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:explainLabel];
    _explainLabel = explainLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = CGRectGetWidth(frame) / 2.0;
        
        [self initWithSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initWithSubView];
    }
    return self;
}

#pragma mark - 更改波浪的颜色
- (void)setFrontWaveColor:(UIColor *)frontWaveColor {
    self.waterWaveView.frontWaveColor = frontWaveColor;
}

- (void)setBackWaveColor:(UIColor *)backWaveColor {
    self.waterWaveView.backWaveColor = backWaveColor;
}

- (void)increaseWaveByPercent:(CGFloat)percent {
    self.percent += percent;
    
    if (self.percent >= 0.2) {
        self.frontWaveColor = [UIColor colorWithRed:92 / 255.0 green:189 / 255.0 blue:15 / 255.0 alpha:1];
        self.backWaveColor = [UIColor colorWithRed:123 / 255.0 green:205 / 255.0 blue:57 / 255.0 alpha:1];
    }
    
    if (self.percent >= 1.0) {
        self.percent = 1.0;
    }
    NSInteger num = self.percent * 100;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", num];

    [self startWave];
}

- (void)decreaseWaveByPercent:(CGFloat)percent {
    self.percent -= percent;
    
    if (self.percent <= 0.2) {
        self.frontWaveColor = [UIColor redColor];
        self.backWaveColor = [UIColor redColor];
    }
    if (self.percent <= 0) {
        self.percent = 0;
    }
    
    
    NSInteger num = self.percent * 100;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", num];
    
    [self startWave];
}

#pragma mark - 开始波浪效果
- (void)startWave {
    if (_numberLabel.text) {
        if (self.percent >= 0) {
            self.waterWaveView.percent = _percent;
            [self.waterWaveView startWave];
        } else {
            [self resetWave];
        }
    }
}

#pragma mark - 停止波浪效果
- (void)stopWave {
    [self.waterWaveView stopWave];
}

#pragma mark - 重置波浪效果
- (void)resetWave {
    [self.waterWaveView reset];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat viewHeight = CGRectGetHeight(self.frame);
    CGFloat viewWidth = CGRectGetWidth(self.frame);
    
    self.backgroundImageView.frame = self.bounds;
    
    self.waterWaveView.frame = CGRectMake(_waveViewEdge.left, _waveViewEdge.top, viewWidth-_waveViewEdge.left - _waveViewEdge.right, viewHeight - _waveViewEdge.top - _waveViewEdge.bottom);
    
    self.waterWaveView.layer.cornerRadius = MIN(CGRectGetHeight(_waterWaveView.frame) / 2, CGRectGetWidth(_waterWaveView.frame) / 2);
    
    CGFloat numberLabelWidth = viewWidth * 2 / 3.0;
    CGFloat numberLabelHeight = _numberLabel.font.pointSize + 2;
    
    CGFloat explainLabelWidth = viewWidth * 3 / 4.0;
    CGFloat explainLabelHeight = _explainLabel.font.pointSize;
    
    self.numberLabel.frame = CGRectMake((viewWidth - numberLabelWidth) / 2, (viewHeight - numberLabelHeight - explainLabelHeight) / 2, numberLabelWidth, numberLabelHeight);
    
    if (_unitLabel.text.length > 0) {
        self.unitLabel.frame = CGRectMake(viewWidth * 0.8, CGRectGetMinY(_numberLabel.frame) * 1.2, _unitLabel.font.pointSize * 3, _unitLabel.font.pointSize);
    } else {
        self.unitLabel.frame = CGRectZero;
    }
    
    self.explainLabel.frame = CGRectMake((viewWidth - explainLabelWidth)/2, CGRectGetMaxY(_numberLabel.frame) - numberLabelHeight/30, explainLabelWidth, explainLabelHeight);
}

- (void)dealloc {
    [self stopWave];
}

@end
