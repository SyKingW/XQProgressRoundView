//
//  XQLightProgressImgView.h
//  XQLocalizedString
//
//  Created by WXQ on 2018/4/20.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XQProgressRoundViewTrackingType) {
    XQProgressRoundViewTrackingTypeBegin = 0,
    XQProgressRoundViewTrackingTypeContinue,
    XQProgressRoundViewTrackingTypeEnd,
    XQProgressRoundViewTrackingTypeCancel,
};

typedef void(^XQProgressRoundViewCallback)(XQProgressRoundViewTrackingType type, CGFloat angle, CGFloat progress);

@interface XQProgressRoundView : UIControl

/**
 圆点大小
 */
@property (nonatomic, assign) CGFloat roundRadius;

/**
 圆点颜色
 */
@property (nonatomic, strong) UIColor *roundColor;

/**
 线开始角度 0 ~ 360, 0角度为3点钟, 现在是默认顺时针
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 线结束角度
 */
@property (nonatomic, assign) CGFloat endAngle;

/**
 移动圆回调
 cancel的时候是获取不到angle的, 现在是返回当前圆点位置
 */
@property (nonatomic, copy) XQProgressRoundViewCallback callback;


@end













