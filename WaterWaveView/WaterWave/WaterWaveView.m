//
//  WaterWaveView.m
//  WaterWaveView
//
//  Created by 酌晨茗 on 16/1/14.
//  Copyright (c) 2016 酌晨茗. All rights reserved.
//
#import "WaterWaveView.h"

@interface WaterWaveView ()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;

@property (nonatomic, strong) CAShapeLayer *frontWaveLayer;
@property (nonatomic, strong) CAShapeLayer *backWaveLayer;

@end

@implementation WaterWaveView {

    CGFloat waveAmplitude;  // 波纹振幅
    CGFloat waveCycle;      // 波纹周期
    CGFloat waveSpeed;      // 波纹速度
    CGFloat waveGrowth;     // 波纹上升速度
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;           // 波浪x位移
    CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）
    
    float variable;     //可变参数 更加真实 模拟波纹
    BOOL increase;      // 增减变化
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self initDefaultProperties];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self initDefaultProperties];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    waterWaveHeight = self.frame.size.height / 2.0;
    waterWaveWidth = self.frame.size.width;
    if (waterWaveWidth > 0) {
        waveCycle =  1.29 * M_PI / waterWaveWidth;
    }
    
    if (currentWavePointY <= 0) {
        currentWavePointY = self.frame.size.height;
    }
}

- (void)initDefaultProperties {
    waterWaveHeight = self.frame.size.height / 2.0;
    waterWaveWidth = self.frame.size.width;
    
    self.frontWaveColor = [UIColor colorWithRed:92 / 255.0 green:189 / 255.0 blue:15 / 255.0 alpha:1];
    self.backWaveColor = [UIColor colorWithRed:123 / 255.0 green:205 / 255.0 blue:57 / 255.0 alpha:1];
    
    waveGrowth = 0.85;
    waveSpeed = 0.4 / M_PI;
    
    [self resetProperty];
}

- (void)resetProperty {
    currentWavePointY = self.frame.size.height;
    
    variable = 1.6;
    increase = NO;
    
    offsetX = 0;
}

#pragma mark - set方法
- (void)setFrontWaveColor:(UIColor *)frontWaveColor {
    _frontWaveColor = frontWaveColor;
    self.frontWaveLayer.fillColor = frontWaveColor.CGColor;
}

- (void)setBackWaveColor:(UIColor *)backWaveColor {
    _backWaveColor = backWaveColor;
    self.backWaveLayer.fillColor = backWaveColor.CGColor;
}

- (void)setPercent:(CGFloat)percent {
    if (percent < _percent) {
        // 下降
        waveGrowth = waveGrowth > 0 ? -waveGrowth : waveGrowth;
    } else if (percent > _percent) {
        // 上升
        waveGrowth = waveGrowth > 0 ? waveGrowth : -waveGrowth;
    }
    _percent = percent;
}

#pragma mark - 开始
- (void)startWave {
    if (self.frontWaveLayer == nil) {
        self.frontWaveLayer = [CAShapeLayer layer];
        self.frontWaveLayer.fillColor = _frontWaveColor.CGColor;
        [self.layer addSublayer:_frontWaveLayer];
    }
    
    if (self.backWaveLayer == nil) {
        self.backWaveLayer = [CAShapeLayer layer];
        self.backWaveLayer.fillColor = _backWaveColor.CGColor;
        [self.layer addSublayer:_backWaveLayer];
    }

    if (_waveDisplaylink == nil) {
        self.waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
        [self.waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)reset {
    [self stopWave];
    [self resetProperty];
    
    if (_frontWaveLayer) {
        [self.frontWaveLayer removeFromSuperlayer];
        self.frontWaveLayer = nil;
    }
    
    if (_backWaveLayer) {
        [self.backWaveLayer removeFromSuperlayer];
        self.backWaveLayer = nil;
    }
}

- (void)animateWave {
    if (increase) {
        variable += 0.01;
    } else {
        variable -= 0.01;
    }
    
    if (variable <= 1) {
        increase = YES;
    }
    
    if (variable >= 1.6) {
        increase = NO;
    }
    
    waveAmplitude = variable * 5;
}

- (void)getCurrentWave:(CADisplayLink *)displayLink {
    
    [self animateWave];

    if (waveGrowth > 0 && currentWavePointY > 2 * waterWaveHeight * (1 - _percent)) {
        // 波浪高度未到指定高度 继续上涨
        currentWavePointY -= waveGrowth;
    } else if (waveGrowth < 0 && currentWavePointY < 2 * waterWaveHeight * (1 - _percent)){
        currentWavePointY -= waveGrowth;
    }
    
    // 波浪位移
    offsetX += waveSpeed;

    [self setFrontWaveLayerPath];

    [self setBackWaveLayerPath];
}

#pragma mark - 绘制波浪线
- (void)setFrontWaveLayerPath {
    self.backgroundColor = [UIColor clearColor];
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= waterWaveWidth; x++) {
        // 正弦波浪公式
        y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
        CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    }
    CGPathCloseSubpath(path);
    self.frontWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)setBackWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= waterWaveWidth; x++) {
        // 余弦波浪公式
        y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
        CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
        CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    }
    CGPathCloseSubpath(path);
    _backWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)stopWave {
    if (_waveDisplaylink) {
        [self.waveDisplaylink invalidate];
        self.waveDisplaylink = nil;
    }
}

- (void)dealloc {
    [self reset];
}

@end
