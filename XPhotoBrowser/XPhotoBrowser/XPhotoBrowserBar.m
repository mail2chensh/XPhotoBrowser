//
//  XPhotoBrowserBar.m
//  XPhotoBrowser
//
//  Created by dev on 15/6/26.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import "XPhotoBrowserBar.h"

@interface XPhotoBrowserBar ()
{
    UIView *_bgView;
}
@end

@implementation XPhotoBrowserBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    //
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgView.backgroundColor = [UIColor colorWithRed:0x01/255.0f green:0xbb/255.0f blue:0x91/255.0f alpha:1.0f];
    [self addSubview:_bgView];
    //
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake((self.frame.size.width - 200.0f) / 2, (self.frame.size.height - 44.0f), 200.0f, 44.0f);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self addSubview:self.titleLabel];
    //
    self.leftButton = [self createButton:CGRectMake(10, self.frame.size.height - 44 - 10, 44, 44) withNormalStateImage:[UIImage imageNamed:@"返回.png"] withTarget:self withAction:@selector(leftButtonDidTouch:) isleft:YES];
    [self addSubview:self.leftButton];
    
    self.rightButton = [self createButton:CGRectMake(self.frame.size.width - 44 - 10, self.frame.size.height - 44 - 10, 44, 44) withNormalStateImage:[UIImage imageNamed:@"查看大图删除键.png"] withTarget:self withAction:@selector(rightButtonDidTouch:) isleft:NO];
    [self addSubview:self.rightButton];
    
}

- (void)leftButtonDidTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(photoBrowserBarLeftButtonDidTouch)]) {
        [self.delegate photoBrowserBarLeftButtonDidTouch];
    }
}

- (void)rightButtonDidTouch:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(photoBrowserBarRightButtonDidTouch)]) {
        [self.delegate photoBrowserBarRightButtonDidTouch];
    }
}

- (UIButton *)createButton:(CGRect)frame withNormalStateImage:(UIImage*)nImage withTarget:(id)target  withAction:(SEL)action isleft:(BOOL)isleft
{
    UIButton *commonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [commonButton setImage:nImage forState:UIControlStateNormal];
    commonButton.frame = frame;
    commonButton.backgroundColor = [UIColor clearColor];
    [commonButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:nImage];
    imageView.frame = CGRectMake(isleft ? 0 : (commonButton.frame.size.width - nImage.size.width / 2), commonButton.frame.size.height - nImage.size.height / 2, nImage.size.width / 2, nImage.size.height / 2);
    [commonButton addSubview:imageView];
    return commonButton;
}

- (void)setHiddenDeleteButton:(BOOL)hiddenDeleteButton
{
    _hiddenDeleteButton = hiddenDeleteButton;
    self.rightButton.hidden = _hiddenDeleteButton;
}

@end
