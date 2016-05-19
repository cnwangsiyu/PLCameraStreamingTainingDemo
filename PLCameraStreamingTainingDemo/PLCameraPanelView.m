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
        
        NSArray *switches = [self _generateSwitchesWithTitles:@[@"摄像头开关"]];
        
        _captureSwitch = switches[0];
        
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

- (NSArray *)_generateSwitchesWithTitles:(NSArray *)titles
{
    UISwitch *previousSwitch = nil;
    NSMutableArray *switches = [[NSMutableArray alloc] initWithCapacity:titles.count];
    
    for (NSString *title in titles) {
        UISwitch *switchBar = [self _generateSwitchWithTitle:title previousSwitch:previousSwitch];
        previousSwitch = switchBar;
        [switches addObject:switchBar];
    }
    return switches;
}

- (UISwitch *)_generateSwitchWithTitle:(NSString *)title previousSwitch:(UISwitch *)previousSwitch
{
    UISwitch *switchBar = [[UISwitch alloc] init];
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:switchBar];
    [self addSubview:label];
    [switchBar setOn:YES];
    [label setText:title];
    [switchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (previousSwitch) {
            make.left.equalTo(previousSwitch.mas_right).with.offset(5);
        } else {
            make.left.equalTo(self).with.offset(10);
        }
        make.bottom.equalTo(self).with.offset(-10);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(switchBar.mas_right);
        make.bottom.equalTo(switchBar.mas_bottom);
    }];
    return switchBar;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.cameraStreamingSession updatePreviewViewSize:self.cameraContainerView.bounds.size];
}

@end
