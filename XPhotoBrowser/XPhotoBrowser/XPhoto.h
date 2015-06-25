//
//  XPhoto.h
//  XPhotoBrowser
//
//  Created by dev on 15/6/25.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XPhoto : NSObject

@property (nonatomic, assign) int index;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *srcImageView;

@end
