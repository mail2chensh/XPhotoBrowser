//
//  XPhotoView.h
//  XPhotoBrowser
//
//  Created by dev on 15/6/25.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPhoto, XPhotoView, XPhotoBrowserViewController;

@protocol XPhotoViewDelegate <NSObject>

- (void)photoViewSingleTap:(XPhotoView*)photoView;
- (void)photoViewDidEndZoom:(XPhotoView*)photoView;

@end


@interface XPhotoView : UIScrollView

@property (nonatomic, weak) id<XPhotoViewDelegate> photoViewDelegate;

@property (nonatomic, strong) XPhoto *photo;

- (void)resetZoomScale;

@end
