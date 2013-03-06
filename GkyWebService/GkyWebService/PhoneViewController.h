//
//  TestViewController.h
//  GkyWebService
//
//  Created by siteview on 12-9-5.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface PhoneViewController : UITableViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,MBProgressHUDDelegate>
{
    NSMutableData      *infoData;
    UITextField         *phoneText;
    NSURLConnection     *phoneConnection;
    MBProgressHUD       *progress;
    
    MBProgressHUD       *errorInfoHUD;
}

@end
