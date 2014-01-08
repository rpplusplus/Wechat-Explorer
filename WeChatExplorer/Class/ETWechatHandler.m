//
//  ETWechatHandler.m
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-4.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import "ETWechatHandler.h"

static ETWechatHandler* _sharedhandler = nil;
@implementation ETWechatHandler

- (BOOL)        searchWechat
{
    self.wechatRootDirectory = [self.device newAFCApplicationDirectory:@"com.tencent.xin"];
    return self.wechatRootDirectory != NULL;
}

- (BOOL)        searchWechatUserName
{
    assert(self.wechatRootDirectory);
    NSArray* arr = [self.wechatRootDirectory directoryContents:@"Documents"];
    self.wechatUserName = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary* dict = [self.wechatRootDirectory getFileInfo:[NSString stringWithFormat:@"Documents/%@", obj]];
        if ([dict[@"st_ifmt"] isEqualToString:@"S_IFDIR"])
        {
            if (![obj isEqualToString:@"00000000000000000000000000000000"])
            {
                [self.wechatUserName addObject:obj];
            }
        }
    }];
    
    return self.wechatUserName != NULL;
}

- (NSString*)   wechatAudioRootPath:(NSString*) userName
{
    return [NSString stringWithFormat:@"Documents/%@/Audio", userName];
}

- (NSArray*)    wechatAudioUserFolder:(NSString*) userName
{
    return [self.wechatRootDirectory directoryContents:[self wechatAudioRootPath: userName]];
}

- (NSArray*)    wechatAudioFilesWithUser:(NSString*) userName
                              folderName:(NSString*) folderName;
{
    return [self.wechatRootDirectory directoryContents:[[self wechatAudioRootPath: userName] stringByAppendingFormat:@"/%@", folderName]];
}

- (BOOL)        moveUser:(NSString*) userName
              folderName:(NSString*) folderName
                 audFile:(NSString*) fileName
                  toPath:(NSString*) path
              convertAMR:(BOOL) convert
{
    NSString* filePath = [[self wechatAudioRootPath: userName] stringByAppendingFormat:@"/%@/%@", folderName,fileName];
    AFCFileReference* fileHandler = [self.wechatRootDirectory openForRead:filePath];
    
    NSMutableData* data = [NSMutableData data];

    if (convert)
    {
        NSString* str = @"#!AMR\n";
        [data appendBytes:[str UTF8String] length:6];
    }

    while (true) {
        char* buffer = malloc(sizeof(char) * 1024* 8);
        NSInteger len = [fileHandler readN:1024 bytes:buffer];
        
        if (len == 0)
        {
            [fileHandler closeFile];
            break;
        }
        else
        {
            [data appendBytes:buffer length:len];
        }
    }
    
    return [data writeToFile:path
                  atomically:NO];
}

- (id) initWithDevice:(AMDevice *)device
{
    if (self= [super init])
    {
        self.device = device;
    }
    return self;
}

@end
