//
//  ExpressSearchViewController.h
//  GkyWebService
//
//  Created by mario on 12-9-8.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface ExpressSearchViewController : UIViewController<UISearchBarDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *paramSearchBar;
    NSInteger    expressType;
    
    NSArray    *comanyList;
    NSArray    *expressTypeList;
    UITableView   *dataTableView;
    
    NSMutableArray      *dataList;
    MBProgressHUD       *progress;
    MBProgressHUD       *errorInfoHUD;


}
@property(nonatomic,readwrite)NSInteger   expressType;
@end
