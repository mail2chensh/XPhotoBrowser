//
//  XPhotoBrowserViewController.m
//  XPhotoBrowser
//
//  Created by dev on 15/6/25.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import "XPhotoBrowserViewController.h"
#import "XPhoto.h"
#import "XPhotoView.h"
#import "XPhotoBrowserBar.h"

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)
#define HEIGHT_OF_X_NAVIGATION_BAR (([[UIDevice currentDevice].systemVersion floatValue] > 7.0) ? 64.0f : 44.0f)


@interface XPhotoBrowserViewController () <UIScrollViewDelegate, XPhotoViewDelegate, XPhotoBrowserBarDelegate, UIActionSheetDelegate>
{
    UIScrollView *_photoScrollView;
    NSMutableArray *_viewsArray;
    BOOL _hiddenNavBar;
    XPhotoBrowserBar *_bar;
}
@end

@implementation XPhotoBrowserViewController

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
    
    _bar = [[XPhotoBrowserBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_OF_X_NAVIGATION_BAR)];
    _bar.delegate = self;
    _bar.hiddenDeleteButton = self.hiddenDeleteButton;
    [self.view addSubview:_bar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewsArray = [NSMutableArray array];
    
    [self createScrollView];
    [self createPhotoViews];
    
    [self.view bringSubviewToFront:_bar];
    [self updateNavigationTitleBar];
}

- (void)createScrollView
{
    CGRect frame = self.view.bounds;
    
    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _photoScrollView.pagingEnabled = YES;
    _photoScrollView.delegate = self;
    _photoScrollView.showsHorizontalScrollIndicator = NO;
    _photoScrollView.showsVerticalScrollIndicator = NO;
    _photoScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_photoScrollView];

    NSInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self];
    _photoScrollView.contentSize = CGSizeMake(frame.size.width * count, 0);
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
}

- (void)createPhotoViews
{
    NSInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self];
    for (int i = 0; i < count; i++) {
        XPhotoView *pView = [self photoViewWithIndex:i];
        pView.photoViewDelegate = self;
        [_photoScrollView addSubview:pView];
        [_viewsArray addObject:pView];
    }
}

- (XPhotoView*)photoViewWithIndex:(NSInteger)index
{
    XPhotoView *pView = [[XPhotoView alloc] initWithFrame:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    XPhoto *photo = [self.dataSource photoBrowser:self photoOfIndex:index];
    pView.photo = photo;
    return pView;
}

- (void)deletePhotoView:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"真的要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除 照片" otherButtonTitles: nil];
    [actionSheet showInView:self.view];
}

- (void)deletePhotoViewWithIndex:(NSInteger)index
{
    XPhotoView *view = [_viewsArray objectAtIndex:index];
    [view removeFromSuperview];
    [_viewsArray removeObjectAtIndex:index];
    
    NSInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self] - 1;
    for (int i = (int)index; i < count; i++) {
        XPhotoView *tempView = [_viewsArray objectAtIndex:i];
        tempView.frame = CGRectMake(self.view.frame.size.width * i, 0, tempView.frame.size.width, tempView.frame.size.height);
    }
    
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didDeletePhotoAtIndex:)]) {
        [self.delegate photoBrowser:self didDeletePhotoAtIndex:index];
    }
    
    [self updateNavigationTitleBar];
    
    if (count == 0) {
        [self photoBrowserBarLeftButtonDidTouch];
        return;
    }
    if (_currentPhotoIndex == count) {
        _currentPhotoIndex --;
    }
}

- (void)reloadData
{
    NSInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self];
    _photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width * count, 0);
    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * self.view.frame.size.width, 0);
}

- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
{
    _currentPhotoIndex = currentPhotoIndex;
}

- (void)updateNavigationTitleBar
{
    NSUInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self];
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _bar.titleLabel.text = [NSString stringWithFormat:@"%d/%d", (int)_currentPhotoIndex + 1, (int)count];
}


#pragma mark - photoview delegate
- (void)photoViewSingleTap:(XPhotoView *)photoView
{
    _hiddenNavBar = !_hiddenNavBar;
    [UIView animateWithDuration:0.1f animations:^{
        _bar.frame = CGRectMake(0, _hiddenNavBar ? -_bar.frame.size.height : 0, _bar.frame.size.width, _bar.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:_hiddenNavBar];
}

- (void)photoViewDidEndZoom:(XPhotoView *)photoView
{
    
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateNavigationTitleBar];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int count = (int)_viewsArray.count;
    for (int i = 0 ; i < count ; i++) {
        if (i != _currentPhotoIndex) {
            XPhotoView *tempView = [_viewsArray objectAtIndex:i];
            [tempView resetZoomScale];
        }
    }
}


#pragma mark - 
- (void)photoBrowserBarLeftButtonDidTouch
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowserBarRightButtonDidTouch
{
    [self deletePhotoView:nil];
}

#pragma mark - 
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deletePhotoViewWithIndex:_currentPhotoIndex];
    }
}

















@end
