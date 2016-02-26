//
//  ViewController.m
//  WaterWaveView
//
//  Created by 酌晨茗 on 15/4/15.
//  Copyright (c) 2015年 酌晨茗. All rights reserved.
//

#import "ViewController.h"
#import "WaveBallView.h"

@interface ViewController ()

@property (nonatomic, weak) WaveBallView *WaveBallView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addWaveBallView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2.0, CGRectGetMinY(self.WaveBallView.frame) - 50, 150, 30)];
    lable.backgroundColor = [UIColor orangeColor];
    lable.text = @"点击下面的球充电";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [self.view addSubview:lable];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((self.view.frame.size.width - 100) / 2.0, CGRectGetMaxY(self.WaveBallView.frame) + 20, 100, 30);
    [button setTitle:@"用电" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(decreaseWave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)addWaveBallView {
    WaveBallView *waveBallView = [[WaveBallView alloc] initWithFrame:CGRectMake(0, 44, 150, 150)];
    waveBallView.center = self.view.center;
    waveBallView.backgroundColor = [UIColor colorWithRed:226 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1];
    
    //    WaveBallView.waveViewEdge = UIEdgeInsetsMake(15, 15, 20, 20);
//    WaveBallView.backgroundImageView.image = [UIImage imageNamed:@""];
    
    
    waveBallView.numberLabel.text = @"20";
    
    waveBallView.numberLabel.textColor = [UIColor whiteColor];
    waveBallView.unitLabel.text = @"%";

    waveBallView.unitLabel.textColor = [UIColor whiteColor];
    waveBallView.explainLabel.text = @"电量";

    waveBallView.explainLabel.textColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(increaseWave)];
    [waveBallView addGestureRecognizer:tap];
    
    waveBallView.percent = 0.20;
    [self.view addSubview:waveBallView];
    self.WaveBallView = waveBallView;
    [self.WaveBallView startWave];
}

- (void)increaseWave {
    [self.WaveBallView increaseWaveByPercent:0.1];
}

- (void)decreaseWave {
    [self.WaveBallView decreaseWaveByPercent:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
