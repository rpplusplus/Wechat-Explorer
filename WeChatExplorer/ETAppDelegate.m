//
//  ETAppDelegate.m
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-4.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import "ETAppDelegate.h"
#import "MobileDeviceAccess.h"
#import "ETiDeviceHandler.h"
#import "ETWechatHandler.h"
@implementation ETAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    while ([[ETiDeviceHandler sharedHandler] waitForConnection]) {
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode
                              beforeDate:[NSDate distantFuture]];
    }
}

@end
