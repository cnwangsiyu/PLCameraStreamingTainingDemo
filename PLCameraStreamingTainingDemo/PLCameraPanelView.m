//
//  PLCameraPanelView.m
//  PLCameraStreamingTainingDemo
//
//  Created by TaoZeyu on 16/5/19.
//  Copyright © 2016年 taozeyu. All rights reserved.
//

#import "PLCameraPanelView.h"
#import <Masonry/Masonry.h>
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>

@implementation PLCameraPanelView
{
    __weak PLCameraStreamingSession *_cameraStreamingSession;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _captureSwitch = ({
            UISwitch *switchBar = [[UISwitch alloc] init];
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:switchBar];
            [self addSubview:label];
            [switchBar setOn:YES];
            [label setText:@"摄像头开关"];
            [switchBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).with.offset(10);
                make.bottom.equalTo(self).with.offset(-10);
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(switchBar.mas_right);
                make.bottom.equalTo(switchBar.mas_bottom);
            }];
            switchBar;
        });
        
        _cameraContainerView = ({
            UIView *container = [[UIView alloc] init];
            container.backgroundColor = [UIColor blackColor];
            [self addSubview:container];
            [container mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.left.equalTo(self).with.offset(10);
                make.right.equalTo(self).with.offset(-10);
                make.bottom.equalTo(_captureSwitch.mas_top).with.offset(-5);
            }];
            container;
        });
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.cameraStreamingSession updatePreviewViewSize:self.cameraContainerView.bounds.size];
}

@end
