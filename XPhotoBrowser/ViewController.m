//
//  ViewController.m
//  XPhotoBrowser
//
//  Created by dev on 15/6/25.
//  Copyright (c) 2015年 Chensh. All rights reserved.
//

#import "ViewController.h"
#import "XPhotoBrowserViewController.h"
#import "XPhoto.h"

@interface ViewController () <XPhotoBrowserViewControllerDelegate, XPhotoBrowserViwControllerDataSource>
{
    NSMutableArray *photoArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    photoArray = [NSMutableArray array];
    for (int i = 0;  i < 11; i++) {
        XPhoto *photo = [[XPhoto alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        photo.image = image;
        [photoArray addObject:photo];
    }
}

- (void)buttonDidTouch:(id)sender
{
    XPhotoBrowserViewController *vc = [[XPhotoBrowserViewController alloc] init];
    vc.delegate = self;
    vc.dataSource = self;
    vc.currentPhotoIndex = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)photoBrowser:(XPhotoBrowserViewController *)photoBrowser didDeletePhotoAtIndex:(NSUInteger)index
{
    [photoArray removeObjectAtIndex:index];
    [photoBrowser reloadData];
}

- (void)photoBrowser:(XPhotoBrowserViewController *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    
}

- (XPhoto*)photoBrowser:(XPhotoBrowserViewController *)photoBrowser photoOfIndex:(NSUInteger)index
{
    XPhoto *photo = [photoArray objectAtIndex:index];
    return photo;
}

- (NSInteger)numberOfPhotoInPhotoBrowser:(XPhotoBrowserViewController *)photoBrowser
{
    return photoArray.count;
}

@end
