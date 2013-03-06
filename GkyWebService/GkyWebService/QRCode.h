//
//  QRCode.h
//  GkyWebService
//
//  Created by siteview on 12-9-18.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObjects/SQLitePersistentObject.h"

@interface QRCode : SQLitePersistentObject
{
    NSString *codeType;
    NSString *content;
    NSDate   *createTime;
    NSData   *image;
}
@property(nonatomic,retain)NSString *codeType;
@property(nonatomic,retain)NSString *content;
@property(nonatomic,retain)NSDate   *createTime;
@property(nonatomic,retain)NSData   *image;




@end
