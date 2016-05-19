//
//  ViewController.m
//  PLCameraStreamingTainingDemo
//
//  Created by TaoZeyu on 16/5/18.
//  Copyright © 2016年 taozeyu. All rights reserved.
//

#import "ViewController.h"
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>

#define kStreamCloudURL @"http://pili-demo.qiniu.com/api/stream"

@interface ViewController() <PLCameraStreamingSessionDelegate>
@property (nonatomic, strong) PLCameraStreamingSession *session;
@end

@implementation ViewController
{
    BOOL _isSessionReadToRun;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addNotifications];
    
    NSDictionary *streamJSON = [self _createStreamObjectFromServer];
    NSLog(@"Stream Json %@", streamJSON);
    
    PLStream *stream = [PLStream streamWithJSON:streamJSON];
    
    // 授权后执行
    void (^permissionBlock)(void) = ^{
        PLVideoStreamingConfiguration *videoConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
        PLAudioStreamingConfiguration *audioConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
        
        self.session = [[PLCameraStreamingSession alloc] initWithVideoConfiguration:videoConfiguration
                                                                 audioConfiguration:audioConfiguration
                                                                             stream:stream
                                                                   videoOrientation:AVCaptureVideoOrientationPortrait];
        self.session.delegate = self;
        self.session.previewView = self.view;
        
        [self _startSession];
    };
    
    // 处理未授权情况
    void (^noPermissionBlock)(void) = ^{  };
    
    PLAuthorizationStatus status = [PLCameraStreamingSession cameraAuthorizationStatus];
    
    if (PLAuthorizationStatusNotDetermined == status) {
        [PLCameraStreamingSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
            // 回调确保在主线程，可以安全对 UI 做操作
            granted ? permissionBlock() : noPermissionBlock();
        }];
    } else if (PLAuthorizationStatusAuthorized == status) {
        permissionBlock();
    } else {
        noPermissionBlock();
    }
}

- (NSDictionary *)_createStreamObjectFromServer
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:kStreamCloudURL]];
    request.HTTPMethod = @"POST";
    
    NSHTTPURLResponse *response = nil;
    NSError* err = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    
    if (err != nil || response == nil || data == nil) {
        NSLog(@"get play json faild, %@, %@, %@", err, response, data);
        return nil;
    }
    
    NSDictionary *streamJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    if (err != nil || streamJSON == nil) {
        NSLog(@"json decode error %@", err);
        return nil;
    }
    
    return streamJSON;
}

- (void)_startSession
{
    if (!_isSessionReadToRun) {
        
        NSLog(@"start...");
        _isSessionReadToRun = YES;
        
        [self.session startWithCompleted:^(BOOL success) {
            if (success) {
                NSLog(@"success!!");
            } else {
                NSLog(@"fail!!");
                _isSessionReadToRun = NO;
            }
        }];
    }
    
    
}

- (void)_addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_onEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_onBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_onWillTerminate)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
}

- (void)_onEnterBackground
{
    [self.session stop];
    _isSessionReadToRun = NO;
}

- (void)_onBecomeActive
{
    [self _startSession];
}

- (void)_onWillTerminate
{
    [self.session destroy];
}

@end
