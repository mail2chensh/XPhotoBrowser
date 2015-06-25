//
//  XPhotoBrowserViewController.h
//  XPhotoBrowser
//
//  Created by dev on 15/6/25.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPhoto, XPhotoBrowserViewController;


@protocol XPhotoBrowserViwControllerDataSource <NSObject>

- (XPhoto*)photoBrowser:(XPhotoBrowserViewController*)photoBrowser photoOfIndex:(NSUInteger)index;

- (NSInteger)numberOfPhotoInPhotoBrowser:(XPhotoBrowserViewController*)photoBrowser;

@end


@protocol XPhotoBrowserViewControllerDelegate <NSObject>

- (void)photoBrowser:(XPhotoBrowserViewController*)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;

- (void)photoBrowser:(XPhotoBrowserViewController*)photoBrowser didDeletePhotoAtIndex:(NSUInteger)index;

@end


@interface XPhotoBrowserViewController : UIViewController

@property (nonatomic, weak) id<XPhotoBrowserViewControllerDelegate> delegate;

@property (nonatomic, weak) id<XPhotoBrowserViwControllerDataSource> dataSource;

@property (nonatomic, assign) NSUInteger currentPhotoIndex;





- (void)reloadData;

@end
