//
//  ExpressSearchViewController.m
//  GkyWebService
//
//  Created by mario on 12-9-8.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "ExpressSearchViewController.h"
#import "JSON/JSON.h"
#import "Express.h"
#import "ExpressHistoryViewController.h"
#import "GkyCommon.h"
@interface ExpressSearchViewController ()

@end

@implementation ExpressSearchViewController
@synthesize expressType;


- (void)dealloc
{
    //    [self hudWasHidden:errorInfoHUD];
    [comanyList release];
    [dataList release];
    [paramSearchBar release];
    [expressTypeList release];
    [dataTableView release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        comanyList = [[GkyCommon getExpressTypeText]retain];
        dataList = [[NSMutableArray alloc]init];
        expressTypeList =[[GkyCommon getExpressType]retain];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [comanyList objectAtIndex:expressType];
    
    float statusBarWidth = [UIApplication sharedApplication].statusBarFrame.size.width;
    paramSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, statusBarWidth, 30)];
    paramSearchBar.placeholder=@"输入快递单号";
    paramSearchBar.delegate=self;
    
    UITextField * txtField = [[paramSearchBar subviews] lastObject];
    txtField.returnKeyType=UIReturnKeySearch;
    
    [self.view addSubview:paramSearchBar];
    
    dataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, paramSearchBar.frame.size.height,
                                                                 statusBarWidth,
                                                                 self.view.frame.size.height-paramSearchBar.frame.size.height) style:UITableViewStylePlain];
    dataTableView.dataSource=self;
    //    dataTableView.delegate=self;
    [dataTableView setRowHeight:40];
    [self.view addSubview:dataTableView];
    
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    cell.textLabel.font=[UIFont boldSystemFontOfSize:14];
    cell.textLabel.text=[[dataList objectAtIndex:indexPath.row] objectForKey:@"context"];
    cell.detailTextLabel.text=[[dataList objectAtIndex:indexPath.row] objectForKey:@"time"];
    //    cell.imageView.image = [comanyLogoList objectAtIndex:indexPath.row];
    
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * displayTxt = [[dataList objectAtIndex:indexPath.row] objectForKey:@"context"];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"详情" message:displayTxt delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}



#pragma mark - NSUrlConnection delegete
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self hudWasHidden:progress];
    NSLog(@"error is :%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
    [self showErrorInfoHUD:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self getJsonData:data];
}


-(void)getJsonData:(NSData*)data{
    NSString * jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (jsonString) {
        id jdatas = [jsonString JSONValue];
        
        if ([jdatas isKindOfClass:[NSDictionary class]]) {
            NSArray *temp = [jdatas objectForKey:@"data"];
            if (temp) {
                [dataList setArray:temp];
                [dataTableView reloadData];
                [self hudWasHidden:progress];
                [self saveData:jsonString];
            }
            else{
                [self hudWasHidden:progress];
                [self showErrorInfoHUD:[jdatas objectForKey:@"message"]];
            }
            
        }
        
        
    }
    
    
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar2{
    
    if (![GkyCommon ReachableNetWork]) {
        [self showErrorInfoHUD:@"请检查网络!"];
        return;
    }
    
    NSString *tmpString = paramSearchBar.text;
    tmpString=[tmpString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (tmpString.length==0) {
        [self showErrorInfoHUD:@"订单号不能为空!"];
        [paramSearchBar resignFirstResponder];
        return;
    }
    
    [self showProgressHUB];
    NSURL *url =[NSURL URLWithString:[self returnUrl]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [[[NSURLConnection alloc]initWithRequest:request delegate:self]autorelease];
    [paramSearchBar resignFirstResponder];
    
}

#pragma mark - save search data
-(void)saveData:(NSString*)jsonString{
    //    PeristablePerson *joeSmith = [PersistablePerson findFirstByCriteria:@"WHERE last_name = 'Smith' AND first_name = 'Joe'];
    NSString *type =  [expressTypeList objectAtIndex:expressType];
    
    if (type==nil||type.length==0) {
        return;
    }
    
    Express  *temp = [Express findFirstByCriteria:
                      [NSString stringWithFormat:@"WHERE express_code ='%@' AND express_type='%@'",
                       paramSearchBar.text,
                       type]
                      ];
    
    if (!temp) {
        Express *express = [[Express alloc]init];
        
        express.expressCode=paramSearchBar.text;
        express.content=jsonString;
        express.expressType=[expressTypeList objectAtIndex:expressType];
        //时间戳 当前时间
//        NSTimeInterval timeStamp = [[NSDate date]timeIntervalSince1970];
        express.createTime=[GkyCommon getTimeStamp];
        [express save];
    }
    
}



#pragma mark -handle ProgressHUB
//显示等待框
-(void)showProgressHUB{
    progress = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    progress.tag=120;
    [self.navigationController.view addSubview:progress];
    [self.navigationController.view bringSubviewToFront:progress];
    progress.delegate=self;
    //    progress.labelText=@"正在查询...";
    
    progress.dimBackground=YES;
    [progress show:YES];
    
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (hud) {
        
        [hud removeFromSuperview];
        [hud release];
        hud = nil;
    }
}

-(NSString*)returnUrl{
    NSString *url=
    [NSString stringWithFormat:@"http://api.kuaidi100.com/api?id=6c256be28c492d6a&show=0&muti=1&order=asc&com=%@&nu=%@",
     [expressTypeList objectAtIndex:expressType],
     paramSearchBar.text];
    NSLog(@"%@",url);
    return url;
}

-(void)showErrorInfoHUD:(NSString*)errorInfo{
    //    [phoneText resignFirstResponder];
    errorInfoHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    errorInfoHUD.customView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cry.png"]] autorelease];
    errorInfoHUD.mode=MBProgressHUDModeCustomView;
    
    [self.navigationController.view addSubview:errorInfoHUD];
    [self.navigationController.view bringSubviewToFront:errorInfoHUD];
    errorInfoHUD.tag=190;
    errorInfoHUD.delegate=self;
    errorInfoHUD.labelText=errorInfo;
    errorInfoHUD.dimBackground=YES;
    [errorInfoHUD show:YES];
    [errorInfoHUD hide:YES afterDelay:3];
    //    [errorInfoHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}
@end
