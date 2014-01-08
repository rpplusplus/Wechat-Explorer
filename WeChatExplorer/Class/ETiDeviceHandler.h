//
//  ETiDeviceHandler.h
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-4.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
@interface ETiDeviceHandler : NSObject<MobileDeviceAccessListener>

+ (instancetype)    sharedHandler;
- (BOOL)        waitForConnection;

@end
