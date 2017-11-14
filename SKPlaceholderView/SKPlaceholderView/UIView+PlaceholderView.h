//
//  UIView+PlaceholderView.h
//  CommonDemo
//
//  Created by Sakya on 2017/11/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPlaceholderView.h"


typedef void(^SKPlaceholderViewBlock)(void);

@protocol PlaceholderViewDataSetSource;

@interface UIView (PlaceholderView)
@property (nonatomic, weak) id<PlaceholderViewDataSetSource> sk_dataSetSource;
@property (nonatomic, copy) SKPlaceholderViewBlock sk_tapDectedBlock;
- (void)sk_reloadPlaceholderData;  //刷洗数据
@end

@protocol PlaceholderViewDataSetSource <NSObject>
@optional
//数据条数
- (NSInteger)sk_numberOfPlaceholderViewSetView:(UIView *)currentView;
//占位图的样式
- (SKPlaceholderViewStyle)sk_styleOfPlaceholderViewSetView:(UIView *)currentView;
#pragma mark -- custom
//图片
- (UIImage *)sk_imageOfPlceholderViewSetView:(UIView *)currentView;
- (UIImage *)sk_buttonImageOfPlceholderViewSetView:(UIView *)currentView;
//文字
- (NSAttributedString *)sk_titleOfPlceholderViewLabelSetView:(UIView *)currentView;
- (NSAttributedString *)sk_detailOfPlceholderViewLabelSetView:(UIView *)currentView;


@end
