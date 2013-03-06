//
//  TestViewController.m
//  GkyWebService
//
//  Created by siteview on 12-9-5.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "PhoneViewController.h"
#import "GkyCommon.h"


@implementation PhoneViewController

- (id)init
{
    self = [super init];
    if (self) {
        phoneText = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 180, 30)];
        phoneText.keyboardType=UIKeyboardTypeNumberPad;
        phoneText.returnKeyType=UIReturnKeySearch;
        phoneText.borderStyle=UITextBorderStyleRoundedRect;
                
        UIBarButtonItem *searchBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchPhone)];
        self.navigationItem.rightBarButtonItem=searchBar;
        [searchBar release];
        
     

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"手机归属地查询";
    

    
}



-(void)dealloc{
    [self hudWasHidden:errorInfoHUD];
    [infoData release];
    [phoneText release];
    [phoneConnection cancel];
    [phoneConnection release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark -handle phone search
//显示等待框
-(void)showProgressHUB{
    progress = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    progress.tag=120;
    [self.navigationController.view addSubview:progress];
//    [self.view bringSubviewToFront:progress];
    progress.delegate=self;
    progress.labelText=@"正在查询...";
    progress.dimBackground=YES;
    [progress show:YES];

}



-(void)showErrorInfoHUD:(NSString*)errorInfo{
    [phoneText resignFirstResponder];
    errorInfoHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
       errorInfoHUD.customView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cry.png"]] autorelease];
    errorInfoHUD.mode=MBProgressHUDModeCustomView;
    errorInfoHUD.dimBackground=YES;
    [self.navigationController.view addSubview:errorInfoHUD];
        
    errorInfoHUD.tag=190;
    errorInfoHUD.delegate=self;
    errorInfoHUD.labelText=errorInfo;
    [errorInfoHUD show:YES];
    [errorInfoHUD hide:YES afterDelay:3];
//    [errorInfoHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
}

-(void)showLocationInfo:(NSString*)info{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"你的手机归属地"
                                                    message:info
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil,
                                                            nil];
    [alert show];
    [alert release];
}

//得到移动运营商名称
-(NSString*)mobileCompany{
    
    NSString *company;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
        NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
       
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
   NSString* mobileNum = phoneText.text;
    
    if ([regextestcm evaluateWithObject:mobileNum])
    {
        company=@"移动";
    }
    else if ([regextestcu evaluateWithObject:mobileNum]){
        company=@"联通";
    }
    else if ([regextestct evaluateWithObject:mobileNum]){
        company=@"电信";
    }

    return company;
}
//判断手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)handlePhoneInfo:(NSData *)data{
    
    NSString *info = [self getXMLText:data start:@"<location>" end:@"</location>"];
    
    NSString * company = [self mobileCompany];
    NSString *finalStr =[NSString stringWithFormat:@"%@ %@",info,company];
    
    
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                    message:finalStr
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil,
                           nil];
    [alert show];
    [alert release];

    
}



//查询手机号码
-(void)searchPhone{
    
    if (![GkyCommon ReachableNetWork]) {
        [self showErrorInfoHUD:@"请检查网络!"];
        return;
    }
    
    if (![self isMobileNumber:phoneText.text]) {
        [self showErrorInfoHUD:@"号码格式不正确，请检查!"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled=NO;
    [phoneText resignFirstResponder];
    //有道API
    NSString *urlHead = @"http://www.youdao.com/smartresult-xml/search.s?type=mobile&q=";
    NSString *urlString = [NSString stringWithFormat:@"%@%@",urlHead,phoneText.text];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:urlString]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];


    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];

    [self showProgressHUB];
   }




-(void)hudWasHidden:(MBProgressHUD *)hud{
     
    if (hud) {
        if (hud.tag ==progress.tag) {
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }
        
        [hud removeFromSuperview];
        [hud release];
        hud = nil;
}
    
    
   
    
}

#pragma mark -URLConnection delegate



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [infoData setLength:0];
}



-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error is :%@",[[error userInfo] objectForKey:@"NSLocalizedDescription"]);
    
    [self hudWasHidden:progress];
    [self showErrorInfoHUD:[[error userInfo] objectForKey:@"NSLocalizedDescription"]];


}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{

    [self hudWasHidden:progress];

//    NSString *info = [self getXMLText:data start:@"<location>" end:@"</location>"];
    
    
//    [self showLocationInfo:info];
    
    [self handlePhoneInfo:data];

}






#pragma mark -tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
//    [self customCell:cell atindexPath:indexPath];
    if(indexPath.row==0){
        cell.textLabel.text=@"输入手机号:";
        cell.accessoryView=phoneText;
    }
       
    return cell;
}



//解析XML
- (NSString*) getXMLText: (NSData*) source start:(NSString*)tagS end:(NSString*)tagE
{
	if(nil == source)
    {
        return nil;
    }
    
    //转码成中文
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);

	NSString *revString = [[NSString alloc] initWithData:source encoding:enc];
	
	NSRange rangeS = [revString rangeOfString:tagS];
	NSRange rangeE = [revString rangeOfString:tagE];
	
	if(!rangeS.length || !rangeE.length)
    {
        return nil;
    }
	
	NSRange string;
	string.location = rangeS.location + rangeS.length;
	string.length = rangeE.location - string.location;
	
    NSString * tmpStr = [revString substringWithRange:string];
    if ([tmpStr length])
    {
        return tmpStr;
    }
	return nil;
}



@end
