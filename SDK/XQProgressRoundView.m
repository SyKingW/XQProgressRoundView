//
//  XQLightProgressImgView.m
//  XQLocalizedString
//
//  Created by WXQ on 2018/4/20.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

#import "XQProgressRoundView.h"
#import <XQProjectTool/UIView+ColorProgress.h>

@interface XQProgressRoundView ()

@property (nonatomic, assign) CGPoint currentRoundPoint;
@property (nonatomic, assign) float lastAngle;

@end

@implementation XQProgressRoundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.startAngle = 145;
        self.endAngle = 35;
        self.roundRadius = 10;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 默认点
    [self drawRoundWithAngle:self.startAngle type:XQProgressRoundViewTrackingTypeCancel];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self drawRoundWithPoint:[touch locationInView:self] type:XQProgressRoundViewTrackingTypeBegin];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self drawRoundWithPoint:[touch locationInView:self] type:XQProgressRoundViewTrackingTypeContinue];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self drawRoundWithPoint:[touch locationInView:self] type:XQProgressRoundViewTrackingTypeEnd];
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [self drawRoundWithPoint:CGPointMake(0, 0) type:XQProgressRoundViewTrackingTypeCancel];
    [super cancelTrackingWithEvent:event];
}

// 传入手指的point
- (void)drawRoundWithPoint:(CGPoint)point type:(XQProgressRoundViewTrackingType)type {
    if (type == XQProgressRoundViewTrackingTypeCancel) {
        if (self.callback) {
            CGFloat angle = self.lastAngle;
            CGFloat progress = (angle + angle < self.startAngle ? 0 : 360 - self.startAngle) / (self.endAngle + self.endAngle > self.startAngle ? 0 : 360 - self.startAngle);
            self.callback(type, self.lastAngle, progress);
        }
        return;
    }
    
    // 获取角度
    float angle = AngleFromNorth(CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2), point);
    angle = getCorrectAngle(self.startAngle, angle, self.endAngle);
    [self drawRoundWithAngle:angle type:type];
}

static inline CGFloat getCorrectAngle(CGFloat startAngle, CGFloat angle, CGFloat endAngle) {
        // 超出范围
    if (angle < startAngle && angle > endAngle) {
        // 获取中间线, 比较偏向哪边, 就放到哪边
        if (angle > endAngle + (fabs(startAngle - endAngle)/2.0)) {
            return startAngle;
        }else {
            return endAngle;
        }
    }
    
    return angle;
}

- (void)drawRoundWithAngle:(CGFloat)angle type:(XQProgressRoundViewTrackingType)type {
        // 自身半径
    CGFloat sRadius = self.bounds.size.width/2 - self.roundRadius * 2;
    
        //中心点
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);    
    self.currentRoundPoint = xq_getCircleCoordinateWithCenter(centerPoint, angle, sRadius);
    [self setNeedsDisplay];
    
    self.lastAngle = angle;
    
    CGFloat current = angle + (angle < self.startAngle ? 360 : 0) - self.startAngle;
    CGFloat total = self.endAngle + (self.endAngle > self.startAngle ? 0 : 360) - self.startAngle;
    CGFloat progress = current / total;
    
    if (self.callback) {
        self.callback(type, angle, progress);
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawRoundWithColor:self.roundColor point:self.currentRoundPoint radius:self.roundRadius];
}

@end





