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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *streamJSON = [self _createStreamObjectFromServer];
    NSLog(@"Stream Json %@", streamJSON);
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

@end
