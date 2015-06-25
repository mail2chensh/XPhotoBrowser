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

#define kPadding 10
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface XPhotoBrowserViewController () <UIScrollViewDelegate, XPhotoViewDelegate>
{
    UIScrollView *_photoScrollView;
    NSMutableArray *_viewsArray;
    BOOL _hiddenNavBar;
}
@end

@implementation XPhotoBrowserViewController

- (void)loadView
{
    [super loadView];
    
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(deletePhotoView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewsArray = [NSMutableArray array];
    
    [self createScrollView];
    [self createPhotoViews];
    [self updateNavigationTitleBar];
}

- (void)createScrollView
{
    CGRect frame = self.view.bounds;
//    frame.origin.x -= kPadding;
//    frame.size.width += 2 * kPadding;
    
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
    [self deletePhotoViewWithIndex:_currentPhotoIndex];
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
    
    if (count == 0) {
        [self back];
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

- (void)showPhotoView
{
//    NSUInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self];
//    
//    CGRect visibleBounds = _photoScrollView.bounds;
//    int firstIndex = (int)floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
//    int lastIndex = (int)floorf(CGRectGetMaxX(visibleBounds) / CGRectGetWidth(visibleBounds));
//    if (firstIndex < 0) {
//        firstIndex = 0;
//    }
//    if (firstIndex >= count) {
//        firstIndex = (int)count - 1;
//    }
//    if (lastIndex < 0) {
//        lastIndex = 0;
//    }
//    if (lastIndex >= count) {
//        lastIndex = (int)count - 1;
//    }
//    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
////        [_photoScrollView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0)];
//        [_photoScrollView scrollRectToVisible:CGRectMake(index * self.view.frame.size.width, 0, 0, 0) animated:YES];
//    }
}

- (void)showPhotoViewAtIndex:(NSUInteger)index
{
    
}

- (void)updateNavigationTitleBar
{
    NSUInteger count = [self.dataSource numberOfPhotoInPhotoBrowser:self];
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%d/%d", (int)_currentPhotoIndex + 1, (int)count]];
}


#pragma mark - photoview delegate
- (void)photoViewSingleTap:(XPhotoView *)photoView
{
//    [self.navigationController popViewControllerAnimated:YES];

    _hiddenNavBar = !_hiddenNavBar;
    [self.navigationController setNavigationBarHidden:_hiddenNavBar animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:_hiddenNavBar];
}

- (void)photoViewDidEndZoom:(XPhotoView *)photoView
{
    
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self showPhotoView];
    [self updateNavigationTitleBar];
}

#pragma mark - 
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}




















@end
