//
//  ViewController.m
//  RecordTest
//
//  Created by xubojoy on 2016/11/8.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>
@interface ViewController ()<RPPreviewViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createImageView];
    
    self.replayKitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replayKitBtn.frame = CGRectMake(20, 30, 200, 40);
    self.replayKitBtn.backgroundColor = [UIColor purpleColor];
    [self.replayKitBtn setTitle:@"开始/停止录制" forState:UIControlStateNormal];
    [self.replayKitBtn addTarget:self action:@selector(replayKitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.replayKitBtn];
    
}
- (void) createImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, 100, 100)];
    self.imageView.animationImages = @[[UIImage imageNamed:@"img_01.jpg"],   [UIImage imageNamed:@"img_02.jpg"], [UIImage imageNamed:@"img_03.jpg"], [UIImage imageNamed:@"img_04.jpg"]];
    self.imageView.animationDuration = 1;
    [self.imageView startAnimating];
    [self.view addSubview:self.imageView];
}

//启动或者停止录制回放
- (void)replayKitAction:(UIButton *)sender {
    //判断是否已经开始录制回放
    if (sender.isSelected) {
        //停止录制回放，并显示回放的预览，在预览中用户可以选择保存视频到相册中、放弃、或者分享出去
        [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                //处理发生的错误，如磁盘空间不足而停止等
            }
            if (previewViewController) {
                //设置预览页面到代理
                previewViewController.previewControllerDelegate = self;
                [self presentViewController:previewViewController animated:YES completion:nil];
            }
        }];
        sender.selected = NO;
        return;
    }
    //如果还没有开始录制，判断系统是否支持
    if ([RPScreenRecorder sharedRecorder].available) {
        NSLog(@"OK");
        sender.selected = YES;
        //如果支持，就使用下面的方法可以启动录制回放
        [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError * _Nullable error) {
            NSLog(@"%@", error);
            //处理发生的错误，如设用户权限原因无法开始录制等
        }];
    } else {
        NSLog(@"录制回放功能不可用");
    }
}
//回放预览界面的代理方法
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    //用户操作完成后，返回之前的界面
    [previewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
