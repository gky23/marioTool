//
//  ViewController.m
//  GkyWebService
//
//  Created by siteview on 12-9-5.
//  Copyright (c) 2012年 siteview. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (id)init
{
    self = [super init];
    if (self) {
        infoData = [[NSMutableArray alloc]initWithObjects:@"Train",@"Weather",@"...",@"...",@"...", nil];
//        infoData = [NSMutableArray arrayWithObjects:@"Train",@"Weather",@"...",@"...",@"...", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)dealloc{
    [super dealloc];
    [infoData release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoData.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell...
    
     [self customCell:cell atindexPath:indexPath];

    return cell;
}

-(void)customCell:(UITableViewCell*)cell atindexPath:(NSIndexPath*)indexPath{

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"1";
            break;
        case 1:
            cell.textLabel.text=@"2";
            break;
        case 2:
             cell.textLabel.text=@"3";
            break;
        case 3:
            cell.textLabel.text=@"4";
            break;
        case 4:
            cell.textLabel.text=@"5";
            break;

        default:
            break;
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}





@end
