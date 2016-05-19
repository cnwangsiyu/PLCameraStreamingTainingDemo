//
//  PLCameraPanelView.h
//  PLCameraStreamingTainingDemo
//
//  Created by TaoZeyu on 16/5/19.
//  Copyright © 2016年 taozeyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLCameraStreamingSession;

@interface PLCameraPanelView : UIView

@property (nonatomic, readonly) UIView *cameraContainerView;
@property (nonatomic, readonly) UISwitch *captureSwitch;
@property (nonatomic, weak) PLCameraStreamingSession *cameraStreamingSession;

@end
