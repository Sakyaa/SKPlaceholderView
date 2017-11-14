//
//  SKPlaceholderView.m
//  CommonDemo
//
//  Created by Sakya on 2017/11/9.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKPlaceholderView.h"
#import <Masonry.h>

static CGFloat const BUTTON_HEIGHT = 40.0f;

@implementation SKPlaceholderViewConfiguration
static SKPlaceholderViewConfiguration *defaultConfiguration;
+ (void)setDefaultConfiguration:(SKPlaceholderViewConfiguration *)configuration {
    if (defaultConfiguration) { //只允许设置一次，有值的时候返回
        return;
    }
    defaultConfiguration = [configuration copy]; // 通过拷贝对象，避免配置项后面被修改
}
- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}
+ (instancetype)defaultConfiguration {
    NSAssert(defaultConfiguration, @"未设置 defaultConfiguration，应先调用 +[AreaSelectViewConfiguration setDefaultAlertConfiguration:] 来进行初始化");
    return defaultConfiguration;
}
@end

@implementation SKPlaceholderView {
    SKPlaceholderViewConfiguration *_configuration;
}
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
        [self addConstraints];
        [self setUpDefaultConfig];
        //添加整体的点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
/**
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomView];
        [self addConstraints];
        [self setUpDefaultConfig];
        //添加整体的点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
*/
- (void)setUpDefaultConfig {
    
    _configuration = SKPlaceholderViewConfiguration.defaultConfiguration;
    if (_configuration.detailString) {
        _detailLabel.attributedText = _configuration.detailString;
    }
    if (_configuration.titleString) {
        _titleLabel.attributedText = _configuration.titleString;
    }
    if (_configuration.buttonString) {
        [_button setAttributedTitle:_configuration.buttonString forState:UIControlStateNormal];
    }
    if (_configuration.buttonImage) {
        [_button setImage:_configuration.buttonImage forState:UIControlStateNormal];
    }
    if (_configuration.image) {
        _imageView.image = _configuration.image;
    }
}
- (void)initCustomView {
    
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.detailLabel];
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.button];
}
- (void)addConstraints {
    
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self).multipliedBy(0.8);
        make.height.lessThanOrEqualTo(self).multipliedBy(0.8);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView);
        make.bottom.mas_equalTo(self.backView);
        make.height.offset(0);
        make.top.mas_equalTo(self.detailLabel.mas_bottom);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.backView);
        make.width.offset(10);
        make.height.offset(10);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10);
    }];
}
#pragma mark -- event respone
- (void)reloadAction:(UIButton *)sender {
    _placeholderViewClickBlock ? _placeholderViewClickBlock() : nil;
}
- (void)tapGestureDetected:(UITapGestureRecognizer *)sender {
    _placeholderViewClickBlock ? _placeholderViewClickBlock() : nil;
}
#pragma mark -- publick
//控制页面
- (void)setPlaceholderShowStyle:(SKPlaceholderViewStyle)style {
    switch (style) {
        case SKPlaceholderViewStyleNormal:
            [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
            self.button.hidden = YES;
            break;
        case SKPlaceholderViewStyleRich:
            [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(BUTTON_HEIGHT);
            }];
            self.button.hidden = NO;
            break;
        default:
            break;
    }
    if (self.isHidden == YES) self.hidden = NO;
}
#pragma mark -- settter and getter
- (void)setImage:(UIImage *)image {
    _imageView.image = image;
    //update
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(image.size.width);
        make.height.offset(image.size.height);
    }];
}
- (UIView *)backView {
    if (!_backView) {
        UIView *backView = [[UIView alloc] init];
        _backView = backView;
    }
    return _backView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc] init];
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
    }
    return _imageView;
}
- (UIButton *)button {
    if (!_button) {
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        clickButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        clickButton.hidden = YES;
        [clickButton addTarget:self action:@selector(reloadAction:) forControlEvents:UIControlEventTouchUpInside];
        _button = clickButton;
    }
    return _button;
}

@end
