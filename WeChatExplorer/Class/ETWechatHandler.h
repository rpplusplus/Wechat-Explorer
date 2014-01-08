//
//  ETWechatHandler.h
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-4.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobileDeviceAccess.h"
@interface ETWechatHandler : NSObject

@property (nonatomic, strong)   AFCApplicationDirectory*    wechatRootDirectory;

@property (nonatomic, strong)   NSMutableArray*             wechatUserName;
@property (nonatomic, strong)   AMDevice*                   device;

- (BOOL)        searchWechat;
- (BOOL)        searchWechatUserName;
- (NSString*)   wechatAudioRootPath:(NSString*) userName;
- (NSArray*)    wechatAudioUserFolder:(NSString*) userName;
- (NSArray*)    wechatAudioFilesWithUser:(NSString*) userName
                              folderName:(NSString*) str;
- (BOOL)        moveUser:(NSString*) userName
              folderName:(NSString*) folderName
                 audFile:(NSString*) fileName
                  toPath:(NSString*) path
              convertAMR:(BOOL) convert;

- (id) initWithDevice:(AMDevice*) device;

@end
