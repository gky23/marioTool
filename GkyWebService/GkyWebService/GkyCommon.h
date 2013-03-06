//
//  GkyCommon.h
//  GkyWebService
//
//  Created by mario on 12-9-15.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GkyCommon : NSObject

+ (GkyCommon*) GetInstance;
+ (id) allocWithZone:(NSZone *)zone;
+ (void) ReleaseInstance;

+(NSArray*)getExpressTypeText;
+(NSArray*)getExpressType;
+(NSArray*)getExpressTypeImages;

//URL格式
+(bool)looksLikeAURI:(NSString*)paramString;

//邮箱地址格式
+ (bool) looksLikeAnEmailAddress:(NSString *)paramString;

//获得当前时间
+(NSDate*)getTimeStamp;

+(void)showAlert:(NSString*)title:(NSString*)content;

//网络可连接(WIFI或3G)
+(BOOL)ReachableNetWork;
@end
