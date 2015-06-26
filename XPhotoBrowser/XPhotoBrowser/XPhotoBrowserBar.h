//
//  XPhotoBrowserBar.h
//  XPhotoBrowser
//
//  Created by dev on 15/6/26.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XPhotoBrowserBarDelegate <NSObject>

- (void)photoBrowserBarLeftButtonDidTouch;
- (void)photoBrowserBarRightButtonDidTouch;


@end

@interface XPhotoBrowserBar : UIView

@property (nonatomic, weak) id<XPhotoBrowserBarDelegate> delegate;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UILabel *titleLabel;

@end
