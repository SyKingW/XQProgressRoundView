//
//  XQProgressLabelView.h
//  XQLocalizedString
//
//  Created by WXQ on 2018/4/20.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQProgressRoundView.h"

typedef void(^XQProgressLabelViewBtnCallback)(UIButton *sender);

@interface XQProgressLabelView : UIControl

/**
 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 线开始角度 0 ~ 360, 0角度为3点钟, 现在是默认顺时针
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 线结束角度
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 线彩色 (id)[UIColor blueColor].CGColor 这样的格式
 */
@property (nonatomic, copy) NSArray *lineColorArr;

/**
 线背景色
 */
@property (nonatomic, strong) UIColor *lineBackColor;

/**
 移动圆view
 */
@property (nonatomic, strong) XQProgressRoundView *roundView;

/**
 点击中间按钮回调
 */
@property (nonatomic, copy) XQProgressLabelViewBtnCallback callback;

/// 背景视图
@property (nonatomic, strong) UIImageView *backImgView;

/**
 中间按钮
 */
@property (nonatomic, strong) UIButton *centerBtn;

/**
 最小lab
 */
@property (nonatomic, strong) UILabel *minLab;

/**
 最大lab
 */
@property (nonatomic, strong) UILabel *maxLab;

/**
 改变彩色线进度

 @param progress 0 ~ 1
 */
- (void)changeProgress:(CGFloat)progress;

/**
 背景图片
 */
- (void)setBackImg:(UIImage *)backImg;

/**
 设置中心按钮图片
 */
- (void)setCenterBtnImg:(UIImage *)img state:(UIControlState)state;




@end















