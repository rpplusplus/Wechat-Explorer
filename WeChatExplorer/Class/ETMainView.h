//
//  ETMainView.h
//  WeChatExplorer
//
//  Created by Xiaoxuan Tang on 14-1-5.
//  Copyright (c) 2014年 Xiaoxuan Tang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

#import "ETBrowserNode.h"
@interface ETMainView : NSView<NSBrowserDelegate>

@property (nonatomic, weak) IBOutlet    NSBrowser*      browser;
@property (nonatomic, weak) IBOutlet    NSTextField*    selectLabel;

@property (nonatomic, strong)   NSMutableArray*     dataSource;
@property (nonatomic, weak)     ETBrowserNode*      selectNode;
@property (nonatomic, weak)     ETBrowserNode*      selectFolder;
@property (nonatomic, strong)   AVAudioPlayer*      player;

- (IBAction) playBtnClick:(id)sender;
- (IBAction) saveBtnClick:(id)sender;

@end
