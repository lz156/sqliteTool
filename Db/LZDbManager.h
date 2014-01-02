//
//  LZDbManager.h
//  Db
//
//  Created by lz on 13-12-31.
//  Copyright (c) 2013年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZDbManager : NSObject

@property (assign) IBOutlet NSTextField *txfDbPath;
@property (assign) IBOutlet NSButton *btnSelect;

- (IBAction)btnOpenDbClicked:(id)sender;
- (IBAction)btnOutputClicked:(id)sender;
@end
