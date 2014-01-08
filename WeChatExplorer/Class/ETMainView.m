//
//  ETMainView.m
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-5.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import "ETMainView.h"
#import "MobileDeviceAccess.h"
#import "ETWechatHandler.h"
#import "ETBrowserNode.h"

@implementation ETMainView

- (IBAction) playBtnClick:(id)sender
{
    if (self.selectNode)
    {
        ETWechatHandler* wechat = self.selectNode.wechat;
        ETBrowserNode* folder = self.selectNode.fatherNode;
        ETBrowserNode* userName = folder.fatherNode;
        
        NSString* path = [NSTemporaryDirectory() stringByAppendingString:@"tmp.amr"];
        
        [wechat moveUser:userName.displayName
              folderName:folder.displayName
                 audFile:self.selectNode.displayName
                  toPath:path
              convertAMR:YES];
        
        __autoreleasing NSError* error;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:path]
                                                             error:&error];
        if (!error)
        {
            [self.player prepareToPlay];
            [self.player play];
        }
    }
}

- (IBAction) saveBtnClick:(id)sender
{
    if (self.selectNode)
    {
        ETWechatHandler* wechat = self.selectNode.wechat;
        ETBrowserNode* folder = self.selectNode.fatherNode;
        ETBrowserNode* userName = folder.fatherNode;
        
        NSSavePanel* panel = [NSSavePanel savePanel];
        [panel setAllowedFileTypes:@[@"amr"]];
        long t = [panel runModal];
        NSLog(@"%@", [panel.URL.absoluteString substringFromIndex:7]);
        if (t)
        {
            NSString* path = [panel.URL.absoluteString substringFromIndex:7];
            
            if ([wechat moveUser:userName.displayName
                  folderName:folder.displayName
                     audFile:self.selectNode.displayName
                      toPath:path
                  convertAMR:YES])
            {
                NSLog(@"保存成功");
            }
            else
            {
                NSLog(@"保存失败");
            }
        }
    }
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceListChanged)
                                                 name:@"deviceListChanged"
                                               object:nil];
    
    self.browser.maxVisibleColumns = 4;
    [self.browser setTarget:self];
    [self.browser setAction:@selector(browserCellSelected:)];
    [self.browser setSendsActionOnArrowKeys:YES];
    
    [self buildTree];
}

- (void) buildTree
{
    self.dataSource = [NSMutableArray array];
    NSArray* arr=[MobileDeviceAccess singleton].devices;
    for (AMDevice* device in arr) {
        ETBrowserNode* deviceNode = [[ETBrowserNode alloc] init];
        deviceNode.displayName = device.deviceName;
        deviceNode.type = kDevice;
        deviceNode.fatherNode = nil;
        deviceNode.childrenNode = [NSMutableArray array];
        [self.dataSource addObject:deviceNode];
        
        ETWechatHandler* wechat = [[ETWechatHandler alloc] initWithDevice:device];
        if (![wechat searchWechat]) continue;
        if (![wechat searchWechatUserName]) continue;
        
        NSArray* userNameArr = [wechat wechatUserName];
        for (NSString* userName in userNameArr) {
            ETBrowserNode* userNameNode = [[ETBrowserNode alloc] init];
            userNameNode.displayName = userName;
            userNameNode.fatherNode = deviceNode;
            userNameNode.type = kWechatUserName;
            userNameNode.childrenNode = [NSMutableArray array];
            
            [deviceNode.childrenNode addObject:userNameNode];
            
            NSArray* folderArr = [wechat wechatAudioUserFolder:userName];
            for (NSString* folder in folderArr) {
                ETBrowserNode* folderNode = [[ETBrowserNode alloc] init];
                folderNode.displayName = folder;
                folderNode.fatherNode = userNameNode;
                folderNode.type = kTargetUserName;
                folderNode.childrenNode = [NSMutableArray array];
                
                [userNameNode.childrenNode addObject:folderNode];
                
                NSArray* audioArray = [wechat wechatAudioFilesWithUser:userName
                                                            folderName:folder];
                for (NSString* audio in audioArray) {
                    ETBrowserNode* audioNode = [[ETBrowserNode alloc] init];
                    audioNode.displayName = audio;
                    audioNode.type = kAudioFile;
                    audioNode.fatherNode = folderNode;
                    audioNode.wechat = wechat;
                    [folderNode.childrenNode addObject:audioNode];
                }
            }
        }
    }
}

#pragma mark - NSBrowser Delegate

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item
{
    if (item)
    {
        ETBrowserNode* node = item;
        return node.childrenNode.count;
    }
    else
    {
        return self.dataSource.count;
    }
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {
    
    if (item)
    {
        ETBrowserNode* node = item;
        return node.childrenNode[index];
    }
    else
    {
        return self.dataSource[index];
    }
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    ETBrowserNode *node = (ETBrowserNode *)item;
    return node.type==kAudioFile || node.childrenNode.count==0;
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {
    ETBrowserNode *node = (ETBrowserNode *)item;
    return node.displayName;
}

- (void)browserCellSelected:(id)sender
{
    NSIndexPath* indexPath = [self.browser selectionIndexPath];
    ETBrowserNode* node = [self.browser itemAtIndexPath:indexPath];
    if (node)
    {
        if (node.type==kAudioFile)
        {
            self.selectLabel.stringValue = node.displayName;
            self.selectNode = node;
        }
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification 

- (void) deviceListChanged
{
    [self buildTree];
    [self.browser reloadColumn:0];
}


@end
