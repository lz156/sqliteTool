//
//  LZTableInfoModel.h
//  Db
//
//  Created by lz on 13-12-31.
//  Copyright (c) 2013年 LZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZTableInfoModel : NSObject
{
    NSString       *tableName;
    NSMutableArray *lineArray;
}

@property(nonatomic, retain) NSString *tableName;
@property(nonatomic, retain) NSMutableArray *lineArray;

@end

@interface LineInfoModel : NSObject
{
    NSString *lineName;
    NSString *lineType;
}

@property(nonatomic, retain) NSString *lineName;
@property(nonatomic, retain) NSString *lineType;

@end
