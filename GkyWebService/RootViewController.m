//
//  RootViewController.m
//  GkyWebService
//
//  Created by siteview on 12-9-5.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "RootViewController.h"
#import "PhoneViewController.h"
#import "ExpressViewController.h"
#import "ReaderSampleViewController.h"

@interface RootViewController ()

@end
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.0f
                     animations:^{
                         [self.view setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
                         if (iPhone5) {
                             self.view.frame = CGRectMake(0, 0, 568, 320);
                         }
                         else{
                             self.view.frame = CGRectMake(0, 0, 480, 320);
                         }
                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.2)
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0) {
        //5.0及以后，不整这个，界面错位 整这个带动画的话，容易看到一个白头
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    
   
    
    NSString  *str=@"sdfsdfsf";
       
    PhoneViewController *phoneViewController = [[PhoneViewController alloc]init];
    UINavigationController *phoneNav = [[UINavigationController alloc]initWithRootViewController:phoneViewController];
    [phoneViewController release];
    UITabBarItem * phoneBarItem =  [[UITabBarItem alloc]initWithTitle:@"手机归属地" image:[UIImage imageNamed:@"search.png"] tag:0];
    
    phoneNav.tabBarItem=phoneBarItem;
    
        
    ExpressViewController *expressViewController = [[ExpressViewController alloc]init];
    UINavigationController *expressNav = [[UINavigationController alloc]initWithRootViewController:expressViewController];
    [expressViewController release];
    
    UITabBarItem * expressBarItem = [[UITabBarItem alloc]initWithTitle:@"快递查询" image:[UIImage imageNamed:@"search.png"] tag:1];
    
    expressNav.tabBarItem = expressBarItem;
    
    ReaderSampleViewController *QRCodeViewController = [[ReaderSampleViewController alloc]init];
    UINavigationController *qrCodeNav = [[UINavigationController alloc]initWithRootViewController:QRCodeViewController];
    [QRCodeViewController release];
    UITabBarItem * qrCodeBarItem = [[UITabBarItem alloc]initWithTitle:@"二维码" image:[UIImage imageNamed:@"camera.png"] tag:2];
    
    qrCodeNav.tabBarItem=qrCodeBarItem;
    
    [self setViewControllers:[NSArray arrayWithObjects:expressNav,qrCodeNav,phoneNav, nil]];
    
    [str release];
    [str retain];
   
}

-(BOOL)shouldAutorotate{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
