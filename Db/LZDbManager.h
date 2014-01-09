//
//  LZDbManager.h
//  Db
//
//  Created by lz on 13-12-31.
//  Copyright (c) 2013年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZDbManager : NSObject<NSTableViewDataSource>

@property (assign) IBOutlet NSTextField *txfDbPath;
@property (assign) IBOutlet NSButton *btnSelect;
@property (assign) IBOutlet NSTextField *txfModelPath;
@property (assign) IBOutlet NSTableView *tbVName;
@property (assign) IBOutlet NSTableView *tbVProperty;

- (IBAction)btnOpenDbClicked:(id)sender;
- (IBAction)btnOutputClicked:(id)sender;
- (IBAction)btnEnterModelClicked:(id)sender;
- (IBAction)btnParse:(id)sender;
@end
