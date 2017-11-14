//
//  SKPlaceholderView.h
//  CommonDemo
//
//  Created by Sakya on 2017/11/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SKPlaceholderViewStyle) {
    SKPlaceholderViewStyleNormal = 0,
    SKPlaceholderViewStyleRich = 1 //有文字和图片 按钮 --为了与Configuration 对应不需要重复设置
};
//只能配置一种情况
@interface SKPlaceholderViewConfiguration : NSObject <NSCopying> // 配置类实现了深拷贝
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *buttonImage;
@property (nonatomic) NSAttributedString *titleString;
@property (nonatomic) NSAttributedString *detailString;
@property (nonatomic) NSAttributedString *buttonString;

//style --
@property (nonatomic) NSDictionary *titleAttributes;
@property (nonatomic) NSDictionary *detailAttributes;

// 默认的配置项
@property (class, nonatomic) SKPlaceholderViewConfiguration *defaultConfiguration;
@end

@interface SKPlaceholderView : UIView

#pragma mark -- custom
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;//主要显示标题
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button; //
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^placeholderViewClickBlock)();  //点击重载
- (void)setPlaceholderShowStyle:(SKPlaceholderViewStyle)style;

@end
