//
//  ExpressViewController.m
//  GkyWebService
//
//  Created by mario on 12-9-8.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "ExpressViewController.h"
#import "ExpressSearchViewController.h"
#import "ExpressHistoryViewController.h"
#import "GkyCommon.h"

@interface ExpressViewController ()

@end

@implementation ExpressViewController

- (id)init
{
    self = [super init];
    if (self) {

        
//        comanyList = [[NSArray alloc]initWithObjects:@"顺丰",@"韵达",@"圆通",@"申通",@"中国邮政",@"EMS", nil];
//        comanyLogoList = [[NSArray alloc]initWithObjects:
//                          [UIImage imageNamed:@"shunfeng.jpeg"],
//                          [UIImage imageNamed:@"yunda.jpeg"],
//                         [UIImage imageNamed:@"yt.jpeg"] ,
//                          [UIImage imageNamed:@"sto.jpeg"],
//                         [UIImage imageNamed:@"chinapost.jpeg"] ,
//                          [UIImage imageNamed:@"ems.jpeg"],nil];
        comanyList =[[GkyCommon getExpressTypeText]retain];
        comanyLogoList=[[GkyCommon getExpressTypeImages]retain];
        

         
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [comanyLogoList release];
    [comanyList release];
    [super dealloc];
}


-(BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backTabBarItem = [[UIBarButtonItem alloc]init];
    backTabBarItem.title=@"返回";
    self.navigationItem.backBarButtonItem=backTabBarItem;

    
    self.title=@"快递查询";
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightBtn addTarget:self action:@selector(goHistoryList) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:
//                              [UIImage imageNamed:@"time.png"]
//                              ];
//    [rightBtn addSubview:imageView];
//    [imageView release];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:imageView];
//    self.navigationItem.rightBarButtonItem.style=UIBarButtonItemStyleBordered;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                            target:self
                                            action:@selector(goHistoryList)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    self.hidesBottomBarWhenPushed=NO;
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comanyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...

    UIView *view = [[UIView alloc]init];
    cell.backgroundView=view;
    cell.textLabel.text=[comanyList objectAtIndex:indexPath.row];
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",indexPath.row];
    cell.imageView.image = [comanyLogoList objectAtIndex:indexPath.row];
    

    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;


    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressSearchViewController *searchViewController = [[ExpressSearchViewController alloc]init];
    
    searchViewController.expressType=indexPath.row;
    searchViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchViewController animated:YES];
    [searchViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

    
}


-(void)goHistoryList{
    ExpressHistoryViewController *history = [[ExpressHistoryViewController alloc]init];
    
    [self.navigationController pushViewController:history animated:YES];
    [history release];
    
}


@end
