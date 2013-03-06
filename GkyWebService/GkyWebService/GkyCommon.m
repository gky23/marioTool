//
//  GkyCommon.m
//  GkyWebService
//
//  Created by mario on 12-9-15.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "GkyCommon.h"
#import "Reachability.h"

//static GkyCommon *gkyCommon=nil;

@implementation GkyCommon
static GkyCommon * gkyCommon=nil;

+(GkyCommon*)GetInstance{
    @synchronized(self){
        if (gkyCommon==nil) {
            gkyCommon = [[[self alloc]init]autorelease];
        }
    }
    return gkyCommon;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (gkyCommon == nil) {
            gkyCommon = [super allocWithZone:zone];
            return gkyCommon;
        }
    }
    return nil;
}

+(void)ReleaseInstance{
    if (gkyCommon) {
        [gkyCommon release];
        gkyCommon = nil;
    }
}

//快递类型(中文显示)
+(NSArray*)getExpressTypeText{
    return   [NSArray arrayWithObjects:@"顺丰",@"韵达",@"圆通",@"申通",@"中国邮政",@"EMS", @"德邦",@"中通",nil];
   }

//快递类型(参数)
+(NSArray*)getExpressType{
    return  [NSArray  arrayWithObjects:
             @"shunfeng",
             @"yunda",
             @"yuantong",
             @"shentong",
             @"youzhengguonei",
             @"ems",
             @"debangwuliu",
             @"zhongtong",
             nil];
	
}

//快递公司LOGO
+(NSArray*)getExpressTypeImages{
        return   [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"shunfeng.jpeg"],
                               [UIImage imageNamed:@"yunda.jpeg"],
                               [UIImage imageNamed:@"yt.jpeg"] ,
                               [UIImage imageNamed:@"sto.jpeg"],
                               [UIImage imageNamed:@"chinapost.jpeg"] ,
                               [UIImage imageNamed:@"ems.jpeg"],
                                [UIImage imageNamed:@"debang.jpeg"],
                  [UIImage imageNamed:@"zhongtong.jpeg"]
                  ,nil];

}

+(bool)looksLikeAURI:(NSString*)paramString {
    if ([paramString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
        return false;
    }
    if ([paramString rangeOfString:@":"].location == NSNotFound) {
        return false;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:paramString]];
    return true;
}

+(bool) looksLikeAnEmailAddress:(NSString *)paramString {
    if ([paramString rangeOfString:@"@"].location == NSNotFound) {
        return false;
    }
    if ([paramString rangeOfString:@"."].location == NSNotFound) {
        return false;
    }
    if ([paramString rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]].location != NSNotFound) {
        return false;
    }
    return true;
}

//获得当前时间
+(NSDate*)getTimeStamp{
    NSTimeInterval timeStamp = [[NSDate date]timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:timeStamp];
}

+(void)showAlert:(NSString*)title:(NSString*)content{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title
                                                        message:content
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

+(BOOL)ReachableNetWork{
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]!=kNotReachable) {
        return YES;
    }
    return NO;
}

@end
