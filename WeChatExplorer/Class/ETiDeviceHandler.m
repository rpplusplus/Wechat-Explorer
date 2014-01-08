//
//  ETiDeviceHandler.m
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-4.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import "ETiDeviceHandler.h"

static ETiDeviceHandler*    _handler = nil;
@implementation ETiDeviceHandler

+ (instancetype) sharedHandler
{
    if (!_handler)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _handler = [[ETiDeviceHandler alloc] init];
        });
    }
    return _handler;
}

- (instancetype) init
{
    if (self = [super init])
    {
        [[MobileDeviceAccess singleton] setListener:self];
    }
    return self;
}

- (BOOL) waitForConnection
{
    if ([MobileDeviceAccess singleton].devices.count == 0)
    {
        return YES;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceListChanged"
                                                            object:nil
                                                          userInfo:nil];
        
        return NO;
    }
}

#pragma mark - MobileDeviceAccessListener Delegate

- (void)deviceConnected:(AMDevice*)device
{
    NSLog(@"设备已连接");
    NSLog(@"%@", device);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceListChanged"
                                                        object:nil
                                                      userInfo:nil];
}

/// This method will be called whenever a device is disconnected
- (void)deviceDisconnected:(AMDevice*)device
{
    NSLog(@"设备已断开");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deviceListChanged"
                                                        object:nil
                                                      userInfo:nil];
}

@end
