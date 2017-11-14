//
//  UIView+PlaceholderView.m
//  CommonDemo
//
//  Created by Sakya on 2017/11/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "UIView+PlaceholderView.h"
#import <objc/runtime.h>



static char const * const skEmptyDataView   =       "sk_placeholderView";
static char const * const skTapDectedBlock  =       "UIView_sk_tapDectedBlock";
static char const * const skDataSetSource   =       "UIView_sk_dataSetSource";



@interface SKWeakObjectContainer : NSObject
@property (nonatomic, readonly, weak) id weakObject;
- (instancetype)initWithWeakObject:(id)object;
@end

@interface UIView () <UIGestureRecognizerDelegate>
@property (nonatomic, readonly) SKPlaceholderView *sk_placeholderView;
@end
@implementation UIView (PlaceholderView)

- (SKPlaceholderViewBlock)sk_tapDectedBlock {
    return objc_getAssociatedObject(self, skTapDectedBlock);
}
- (void)setSk_tapDectedBlock:(SKPlaceholderViewBlock)sk_tapDectedBlock {
    objc_setAssociatedObject(self, skTapDectedBlock, sk_tapDectedBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id<PlaceholderViewDataSetSource>)sk_dataSetSource{
    SKWeakObjectContainer *container = objc_getAssociatedObject(self, skDataSetSource);
    return container.weakObject;
}
- (void)setSk_dataSetSource:(id<PlaceholderViewDataSetSource>)sk_dataSetSource{
    objc_setAssociatedObject(self, skDataSetSource, [[SKWeakObjectContainer alloc] initWithWeakObject:sk_dataSetSource], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)sk_reloadPlaceholderData {
//线判断数据有无
    NSInteger dataNumber = [self sk_number];
    if (dataNumber > 0) {
        if (self.sk_placeholderView.isHidden == NO) {
            self.sk_placeholderView.hidden = YES;
        }
        return;
    }
//--- show
    SKPlaceholderView *view = self.sk_placeholderView;
    if (!view.superview) {
        //        if (([self isKindOfClass:[UIView class]]) &&
        //            self.subviews.count > 1) {
        //            [self insertSubview:view atIndex:0];
        //        } else {
        [self addSubview:view];
        //        }
    }
    view.hidden = NO;
//    --- custom
    SKPlaceholderViewStyle style = [self sk_plceholderStyle];
    if (style == SKPlaceholderViewStyleRich) {
        [view setPlaceholderShowStyle:style];
        return;
    }
    
    UIImage *image = [self sk_placeholderImage];
    if (image) view.image = image;
    
    UIImage *buttonImage = [self sk_buttonImage];
    NSAttributedString *titleLabelString = [self sk_titleLabelString];
    NSAttributedString *detailLabelString = [self sk_detailLabelString];
    if (buttonImage) {
        [view.button setImage:buttonImage forState:UIControlStateNormal];
    }
    if (titleLabelString) {
        view.titleLabel.attributedText = titleLabelString;
    }
    if (detailLabelString) {
        view.detailLabel.attributedText = detailLabelString;
    }
    [view updateConstraints];
}
#pragma mark - Setters (Private)
- (void)setSk_placeholderView:(SKPlaceholderView *)view {
    objc_setAssociatedObject(self, skEmptyDataView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - Getters (Private)
- (SKPlaceholderView *)sk_placeholderView {
    SKPlaceholderView *view = objc_getAssociatedObject(self, skEmptyDataView);
    if (!view) {
        view = [SKPlaceholderView new];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        view.frame = self.bounds;
        __weak typeof(self) weakSelf = self;
        view.placeholderViewClickBlock = ^{
            weakSelf.sk_tapDectedBlock ? weakSelf.sk_tapDectedBlock() : nil;
        };
        [self setSk_placeholderView:view];
    }
    return view;
}
//图片
- (UIImage *)sk_placeholderImage {
    if (self.sk_dataSetSource &&
        [self.sk_dataSetSource respondsToSelector:@selector(sk_imageOfPlceholderViewSetView:)]) {
        UIImage *placeholderImage = [self.sk_dataSetSource sk_imageOfPlceholderViewSetView:self];
        return placeholderImage;
    }
    return nil;
}
- (UIImage *)sk_buttonImage {
    if (self.sk_dataSetSource &&
        [self.sk_dataSetSource respondsToSelector:@selector(sk_buttonImageOfPlceholderViewSetView:)]) {
        UIImage *buttonImage = [self.sk_dataSetSource sk_buttonImageOfPlceholderViewSetView:self];
        return buttonImage;
    }
    return nil;
}
//tableView cell数据的数量
- (NSInteger)sk_number {
    if (self.sk_dataSetSource &&
        [self.sk_dataSetSource respondsToSelector:@selector(sk_numberOfPlaceholderViewSetView:)]) {
        NSInteger number = [self.sk_dataSetSource sk_numberOfPlaceholderViewSetView:self];
        return number;
    }
    return 0;
}
- (NSAttributedString *)sk_detailLabelString {
    if (self.sk_dataSetSource &&
        [self.sk_dataSetSource respondsToSelector:@selector(sk_detailOfPlceholderViewLabelSetView:)]) {
        NSAttributedString *string = [self.sk_dataSetSource sk_detailOfPlceholderViewLabelSetView:self];
        return string;
    }
    return nil;
}
- (NSAttributedString *)sk_titleLabelString {
    if (self.sk_dataSetSource &&
        [self.sk_dataSetSource respondsToSelector:@selector(sk_titleOfPlceholderViewLabelSetView:)]) {
        NSAttributedString *string = [self.sk_dataSetSource sk_titleOfPlceholderViewLabelSetView:self];
        return string;
    }
    return nil;
}
- (SKPlaceholderViewStyle)sk_plceholderStyle {
    //是没网还是其他样式
    if (self.sk_dataSetSource &&
        [self.sk_dataSetSource respondsToSelector:@selector(sk_styleOfPlaceholderViewSetView:)]) {
        SKPlaceholderViewStyle style = [self.sk_dataSetSource sk_styleOfPlaceholderViewSetView:self];
        return style;
    }
    return 0;
}

@end

#pragma mark - SKWeakObjectContainer
@implementation SKWeakObjectContainer
- (instancetype)initWithWeakObject:(id)object {
    self = [super init];
    if (self) {
        _weakObject = object;
    }
    return self;
}

@end
