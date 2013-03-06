//
//  
//  可以复制的UILabel
//
//  Created by li shiyong on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@interface CopyLabel : UILabel{
    UITapGestureRecognizer       *tapGesture;
    UILongPressGestureRecognizer *longGesture;
}

@end
