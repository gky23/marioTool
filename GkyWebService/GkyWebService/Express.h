//
//  Express.h
//  GkyWebService
//  sqlite数据库 实体类(保存查询记录)
//  Created by siteview on 12-9-12.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObjects/SQLitePersistentObject.h"

@interface Express : SQLitePersistentObject
{
    NSString *content;
    NSString *expressCode;
    NSDate   *createTime;
    NSString *expressType;
}
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSString *expressCode;
@property(nonatomic,retain)NSDate   *createTime;
@property(nonatomic,retain)NSString  *expressType;

@end
