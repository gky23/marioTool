//
//  ExpressHistoryViewController.m
//  GkyWebService
//
//  Created by siteview on 12-9-12.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "ExpressHistoryViewController.h"
#import "Express.h"
//#import "CopyLabel.h"
#import "GkyCommon.h"

@interface ExpressHistoryViewController ()

@end

@implementation ExpressHistoryViewController

- (void)dealloc
{
    [comanyList release];
    [expressTypeList release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

        comanyList = [[GkyCommon getExpressTypeText]retain];
        expressTypeList =[[GkyCommon getExpressType]retain];

//               [Express deleteObject:4 cascade:YES];
        dataList=[[NSArray alloc]
                  initWithArray:[[Express class] allObjects]];
        
        NSLog(@"Total:%d",[dataList count]);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"查询记录";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    
    [btn addTarget:self action:@selector( showAboutInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem=rightBar;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)showAboutInfo{
    UIAlertView *about= [[UIAlertView alloc]initWithTitle:@"说明"
                                                  message:@"搜索历史数据只有在成功搜索到结果后才会保存，并以订单号和快递公司作为唯一标识，保证数据的唯一性。"
                                                 delegate:nil
                                        cancelButtonTitle:@"Close"
                                        otherButtonTitles:nil, nil];
    [about show];
    [about release];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

//    [Express deleteObject:<#(NSInteger)#> cascade:<#(BOOL)#>];
    if ([dataList count]) {
        Express *expressOne =[dataList objectAtIndex:indexPath.row];
        
        cell.textLabel.text=[NSString stringWithFormat:@"单号:%@",expressOne.expressCode];
        
//        NSString *tmpString = expressOne.expressType;
        NSLog(@"%i",expressOne.pk);
//        NSLog(@"%d",[expressTypeList indexOfObject:tmpString]);
        NSString *expressType = [comanyList objectAtIndex:[expressTypeList indexOfObject:expressOne.expressType]];
        NSString *createTime= [self stringFromDate:expressOne.createTime];
        cell.detailTextLabel.text=  [NSString stringWithFormat:@"%@,%@",expressType,createTime];
    }
    
   

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[DetailViewController alloc] initWithNibName:@"Nib name" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    [dateFormatter release];
    return destDateString;
}

-(NSArray *)getAllData{
    NSArray *array = [Express findByCriteria:@"WHERE 1=1"];
    
    return array;
   
}


@end
