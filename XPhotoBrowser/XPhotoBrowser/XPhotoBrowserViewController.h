//
//  XPhotoBrowserViewController.h
//  XPhotoBrowser
//
//  Created by dev on 15/6/25.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XPhotoBrowserViewController;


@protocol XPhotoBrowserViewControllerDelegate <NSObject>

- (void)photoBrowser:(XPhotoBrowserViewController*)photoBrowser;

@end

@interface XPhotoBrowserViewController : UIViewController

@end
