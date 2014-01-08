//
//  ETBrowserNode.h
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-5.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETWechatHandler.h"
enum _ETNodeType {
    kDevice = 0,
    kWechatUserName,
    kTargetUserName,
    kAudioFile
};

typedef enum _ETNodeType ETNodeType;
@interface ETBrowserNode : NSObject

@property (nonatomic, assign)   ETNodeType          type;
@property (nonatomic, strong)   NSString*           displayName;
@property (nonatomic, weak)     ETBrowserNode*      fatherNode;
@property (nonatomic, strong)   NSMutableArray*     childrenNode;
@property (nonatomic, strong)   ETWechatHandler*    wechat;
@end
