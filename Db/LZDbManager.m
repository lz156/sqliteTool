//
//  LZDbManager.m
//  Db
//
//  Created by lz on 13-12-31.
//  Copyright (c) 2013年 LZ. All rights reserved.
//

#import "LZDbManager.h"
#import "FMData.h"
#import "LZTableInfoModel.h"

@interface LZDbManager()
{
    NSUInteger dbTableIndex;
}

@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, retain) NSMutableArray *propertyArray;

-(NSString*)stringByTableType:(NSString*)type;

@end


@implementation LZDbManager
@synthesize dataArray;
@synthesize propertyArray;

- (IBAction)btnOpenDbClicked:(id)sender
{
 
    NSButton *btn = (NSButton*)sender;
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];    
    [panel setPrompt: @"OK"];
    [panel setCanChooseDirectories:NO];
	[panel setCanChooseFiles:YES];
    [panel setAllowedFileTypes:[NSArray arrayWithObjects:@"sqlite",@"db",@"DB",@"SQLITE",@"rdb",@"RDB",nil]]; //   [NSImage imageFileTypes]
    
    NSURL *pathUrl = [[NSURL alloc] initFileURLWithPath:NSHomeDirectory()];
	[panel setDirectoryURL:pathUrl];

    [panel beginSheetModalForWindow:[btn window] completionHandler:^(NSInteger result){
    
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *urls = [panel URLs];
            
            NSURL *url     = [urls objectAtIndex:0];
            NSString *path = [url path];
            
            //NSLog(@"%@",path);
            
            [self.txfDbPath setStringValue:path];
        }
        
        NSLog(@"resutlt:%ld",result);
    
    }];
}

- (IBAction)btnOutputClicked:(id)sender {
    
    //NSButton *btn = (NSButton*)sender;
    
    BOOL isArc = self.btnSelect.state;
    
    //output
    for (LZTableInfoModel *model in dataArray)
    {
        
       
        if (!model.isOn) {
            continue;
        }
        
        NSString *hFileName = [NSString stringWithFormat:@"%@Model.h",[model.tableName capitalizedString]];
        NSString *mFileName = [NSString stringWithFormat:@"%@Model.m",[model.tableName capitalizedString]];
        
        NSMutableString *hString = [NSMutableString stringWithFormat:@"//\n//\n//\n//\n//\n\n"];
        NSMutableString *mString = [NSMutableString stringWithFormat:@"//\n//\n//\n//\n//\n\n"];
        
        
        [hString appendFormat:@"#import <Foundation/Foundation.h> \n\n"];
        [mString appendFormat:@"#import \"%@\"\n\n",hFileName];
        
        NSString *className = [NSString stringWithFormat:@"%@Model",[model.tableName capitalizedString]];
        [hString appendFormat:@"@interface %@ : NSObject{\n\n}\n\n",className];
        [mString appendFormat:@"@implementation %@\n",className];
        
        for (LineInfoModel *infoModel in model.lineArray)
        {
            
            //NSLog(@"%@",infoModel.lineType);
            if (isArc) {
    
                NSString *type = [self stringByTableType:infoModel.lineType];
                if ([type rangeOfString:@"NSString"].length>0 || [type rangeOfString:@"NSDate"].length>0
                    || [type rangeOfString:@"NSData"].length>0) {
                    
                     [hString appendFormat:@"@property(nonatomic, strong) %@%@;\n",[self stringByTableType:infoModel.lineType],infoModel.lineName];
                }
                else
                {
                     [hString appendFormat:@"@property %@%@;\n",[self stringByTableType:infoModel.lineType],infoModel.lineName];
                }
            }
            else
            {
                NSString *type = [self stringByTableType:infoModel.lineType];
                if ([type rangeOfString:@"NSString"].length>0 || [type rangeOfString:@"NSDate"].length>0
                    || [type rangeOfString:@"NSData"].length>0) {
                    
                    [hString appendFormat:@"@property(nonatomic, retain) %@%@;\n",[self stringByTableType:infoModel.lineType],infoModel.lineName];
                }
                else
                {
                    [hString appendFormat:@"@property %@%@;\n",[self stringByTableType:infoModel.lineType],infoModel.lineName];
                }

            }
            
            [mString appendFormat:@"@synthesize %@;\n",infoModel.lineName];
            
        }
        
        if (!isArc)
        {
            [mString appendFormat:@"\n\n- (void)dealloc\n{\n"];
            
            for (LineInfoModel *infoModel in model.lineArray)
            {
                NSString *type = [self stringByTableType:infoModel.lineType];
                if ([type rangeOfString:@"NSString"].length>0 || [type rangeOfString:@"NSDate"].length>0
                    || [type rangeOfString:@"NSData"].length>0) {
                    
                    [mString appendFormat:@"    self.%@ = nil;\n",infoModel.lineName];
                }
            }
            [mString appendFormat:@"\n    [super dealloc];\n}"];
        }
        
        
        
        [hString appendFormat:@"\n\n\n@end"];
        [mString appendFormat:@"\n\n\n@end"];
        
        
        NSString *outputPath = [self.txfModelPath stringValue];//[[[self.txfDbPath stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"lz_model"];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:outputPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:outputPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        
        
        
        NSString *hOutputPath = [outputPath stringByAppendingPathComponent:hFileName];
        
        [hString writeToFile:hOutputPath
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:nil];
        
        NSString *mOutputPath = [outputPath stringByAppendingPathComponent:mFileName];

        [mString writeToFile:mOutputPath
                  atomically:NO
                    encoding:NSUTF8StringEncoding
                       error:nil];
        
    }
}

- (IBAction)btnEnterModelClicked:(id)sender {
    
    NSButton *btn = (NSButton*)sender;
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt: @"OK"];
    [panel setCanChooseDirectories:YES];
	[panel setCanChooseFiles:NO];
    //[panel setAllowedFileTypes:[NSArray arrayWithObjects:@"sqlite",@"db",@"DB",@"SQLITE",@"rdb",@"RDB",nil]]; //   [NSImage imageFileTypes]
    
    NSURL *pathUrl = [[NSURL alloc] initFileURLWithPath:NSHomeDirectory()];
	[panel setDirectoryURL:pathUrl];
    
    [panel beginSheetModalForWindow:[btn window] completionHandler:^(NSInteger result){
        
        if (result == NSFileHandlingPanelOKButton) {
            NSArray *urls = [panel URLs];
            
            NSURL *url     = [urls objectAtIndex:0];
            NSString *path = [url path];
            
            //NSLog(@"%@",path);
            
            [self.txfModelPath setStringValue:path];
        }
        
        NSLog(@"resutlt:%ld",result);
        
    }];

    
    /*
    NSSavePanel *savePanel = [NSSavePanel savePanel];
    [savePanel setPrompt:@"OK"];
    [savePanel setCanCreateDirectories:YES];
    
    NSURL *pathUrl = [[NSURL alloc] initFileURLWithPath:NSHomeDirectory()];
	[savePanel setDirectoryURL:pathUrl];

    
    [savePanel beginSheetModalForWindow:[btn window] completionHandler:^(NSInteger result){
    
        if (result == NSFileHandlingPanelOKButton) {
                        
            NSURL *url     = [savePanel URL];
            NSString *path = [url path];
            
            //NSLog(@"%@",path);
            
            [self.txfModelPath setStringValue:path];
        }
    }];
     */
}

- (IBAction)btnParse:(id)sender {
        
    NSButton *btn = (NSButton*)sender;

    NSString *outputPath = [[[self.txfDbPath stringValue] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"lz_model"];
    [self.txfModelPath setStringValue:outputPath];
    
    NSString *path = [self.txfDbPath stringValue];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        FMDatabase *dataBase = [FMDatabase databaseWithPath:path];
        
        if (![dataBase open])
            NSLog(@"db is not open");
        if ([dataBase hadError])
            NSLog(@"error:%d,%@",[dataBase lastErrorCode],[dataBase lastErrorMessage]);
        
        //read sqlite table name
        NSString *sqlStr = @"select name from sqlite_master where type='table'";
        FMResultSet *resultSet = [dataBase executeQuery:sqlStr];
        
        NSMutableArray *arrayTableName = [NSMutableArray arrayWithCapacity:20];
        while ([resultSet next]) {
            NSString *name =[resultSet stringForColumn:@"name"];
            
            //NSLog(@"name:%@",name);
            [arrayTableName addObject:name];
        }
        [resultSet close];
        
        //read table detail info
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
        for (NSString *tableName in arrayTableName) {
            
            LZTableInfoModel *tableInfoModel = [[LZTableInfoModel alloc] init];
            tableInfoModel.tableName = tableName;
            tableInfoModel.lineArray = [NSMutableArray arrayWithCapacity:20];
            
            FMResultSet *resSet = [dataBase getTableSchema:tableName];
            while ([resSet next]) {
                
                NSString *name = [resSet stringForColumn:@"name"];
                NSString *type = [resSet stringForColumn:@"type"];
                
                LineInfoModel *lineInfoModel = [[LineInfoModel alloc] init];
                lineInfoModel.lineName  = name;
                lineInfoModel.lineType  = type;
                
                [tableInfoModel.lineArray addObject:lineInfoModel];
            }
            [resSet close];
            
            [array addObject:tableInfoModel];
        }
        [dataBase close];
        
        // reload
        self.dataArray = array;
        [self.tbVName reloadData];
        [self.tbVProperty reloadData];

    }
    else
    {
        NSAlert *alert=[NSAlert alertWithMessageText:@"Error"
                                       defaultButton:@"OK"
                                     alternateButton:nil
                                         otherButton:nil
                           informativeTextWithFormat:@"文件路径错误"];
        
        //下面这个方法就是为了能够传递参数给alertEnded:code:context:方法从而进行判断当前所点击的按钮
        [alert beginSheetModalForWindow:[btn window] modalDelegate:self didEndSelector:@selector(alertEnded:code:context:) contextInfo:nil];
        
    }

}

//当点击defaultButton按钮的时候，返回0。当点击alternateButton按钮的时候，返回1；看词义就该了解了啊
-(void)alertEnded:(NSAlert *)alert code:(int)choice context:(void *)v{
    
    if (choice==NSAlertDefaultReturn) {
        
        NSLog(@"----------------0");
        
    } else if(choice==NSAlertAlternateReturn){
        
        NSLog(@"----------------1");
    }
}


-(NSString*)stringByTableType:(NSString*)type
{
    if ([[type uppercaseString] isEqualToString:@"INTEGER"]) {
        return @"NSInteger ";
    }
    
    if ([[type uppercaseString] isEqualToString:@"FLOAT"]) {
        return @"float ";
    }
    
    if ([[type uppercaseString] isEqualToString:@"DOUBLE"]) {
        return @"double ";
    }
    
    if ([[type uppercaseString] isEqualToString:@"BOOLEAN"]) {
        return @"BOOL ";
    }
    
    if ([[type uppercaseString] isEqualToString:@"DATE"]) {
        return @"NSDate *";
    }
    
    if ([[type uppercaseString] isEqualToString:@"TEXT"] || [[type uppercaseString] rangeOfString:@"VARCHAR"].length>0) {
        return @"NSString *";
    }
    
    if ([[type uppercaseString] isEqualToString:@"BLOB"]) {
        return @"NSData *";
    }
    
    return @"";
}


#pragma mark-NSTableViewDatasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSInteger count = 0;
    if (aTableView.tag == 1) {
        count = [dataArray count];
    }
    else
    {
        count = [propertyArray count];
    }
    return count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    
    //NSLog(@"%@",tableColumn.identifier);
    
    if (tableView.tag == 1) {
        
         LZTableInfoModel *model = [dataArray objectAtIndex:row];
        
        if ([tableColumn.identifier isEqualToString:@"cell1"])
        {
            
            BOOL value = [(LZTableInfoModel*)[dataArray objectAtIndex:row] isOn];
            return [NSNumber numberWithInteger:(value ? NSOnState : NSOffState)];
            
        }
        else
        {
            NSString *title = model.tableName;
            return title;
        }
         
    }
    else
    {
        
        LineInfoModel *infoModel = [propertyArray objectAtIndex:row];
        
        if ([tableColumn.identifier isEqualToString:@"cell1"])
        {
            
            NSString *title = infoModel.lineName;
            return title;
        }
        else
        {
            NSString *title = infoModel.lineType;
            return title;
        }
    }
    
    return @"";
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    
    if (aTableView.tag == 1) {
        
        NSString *identifity = [aTableColumn identifier];
        
        LZTableInfoModel *model = [dataArray objectAtIndex:rowIndex];
        
        if ([identifity isEqualToString:@"cell1"]) {
            
            model.isOn = [(NSNumber*)anObject  boolValue];
        }
    }
    
    if (self.propertyArray == nil) {
        
        self.propertyArray = [NSMutableArray arrayWithCapacity:50];
    }
    
    [propertyArray removeAllObjects];
    for (LZTableInfoModel *model in dataArray) {
        
        if (model.isOn) {
            [propertyArray addObjectsFromArray:model.lineArray];
        }
    }
    
    [self.tbVProperty reloadData];
    
    //[self.tbVName reloadData];
}


@end
