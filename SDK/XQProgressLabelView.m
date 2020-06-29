//
//  XQProgressLabelView.m
//  XQLocalizedString
//
//  Created by WXQ on 2018/4/20.
//  Copyright © 2018年 WangXQ. All rights reserved.
//

#import "XQProgressLabelView.h"
#import <XQProjectTool/UIView+ColorProgress.h>

@interface XQProgressLabelView ()

/**
 彩色线结束角度
 */
@property (nonatomic, assign) CGFloat pEndAngle;



@end

@implementation XQProgressLabelView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initUI];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.lineWidth = 15;
    self.startAngle = 155;
    self.endAngle = 25;
    self.pEndAngle = 300;
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.backImgView];
    [self addSubview:self.roundView];
    [self addSubview:self.centerBtn];
    [self addSubview:self.minLab];
    [self addSubview:self.maxLab];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
        // 渐变色的颜色
    NSArray *xqColorArr = @[
                            (id)[UIColor blueColor].CGColor,
                            (id)[UIColor greenColor].CGColor,
                            (id)[UIColor yellowColor].CGColor,
                            (id)[UIColor redColor].CGColor
                            ];
    UIColor *backColor = [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1];
    
    [self drawArcColorProgressWithLineWidth:self.lineWidth
                                     radius:self.bounds.size.width/2 - self.lineWidth
                                centerPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)
                                 startAngle:self.startAngle
                                   endAngle:self.endAngle
                                pStartAngle:self.startAngle
                                  pEndAngle:self.pEndAngle
                                   colorArr:self.lineColorArr ? self.lineColorArr : xqColorArr
                                  backColor:self.lineBackColor ? self.lineBackColor : backColor
                                  clockwise:NO];
    
    //[self.backImgView setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat sWidth = self.bounds.size.width;
    CGFloat sHeight = self.bounds.size.height;
    
    CGFloat imgSize = sWidth - self.lineWidth * 4 - 20;
    self.backImgView.frame = CGRectMake(0, 0, imgSize, imgSize);
    self.roundView.frame = self.backImgView.frame;
    self.centerBtn.frame = CGRectMake(0, 0, imgSize/3.5, imgSize/3.5);
    
    self.backImgView.center = CGPointMake(sWidth/2, sHeight/2);
    self.roundView.center = self.backImgView.center;
    self.centerBtn.center = self.backImgView.center;
    
    
    CGPoint startPoint = xq_getCircleCoordinateWithCenter(CGPointMake(sWidth/2, sHeight/2), self.startAngle, sWidth/2 - self.lineWidth);
    self.minLab.center = CGPointMake(startPoint.x, startPoint.y + self.minLab.bounds.size.height/2 + 10);
    
    CGPoint endPoint = xq_getCircleCoordinateWithCenter(CGPointMake(sWidth/2, sHeight/2), self.endAngle, sWidth/2 - self.lineWidth);
    self.maxLab.center = CGPointMake(endPoint.x, endPoint.y + self.maxLab.bounds.size.height/2 + 10);
}

#pragma mark -- 暴露接口

- (void)changeProgress:(CGFloat)progress {
    if (progress < 0) {
        progress = 0;
    }
    
    if (progress > 1) {
        progress = 1;
    }
    
    CGFloat a = self.endAngle < self.startAngle ? 360 : 0;
    CGFloat total = self.endAngle + a - self.startAngle;
    self.pEndAngle = self.startAngle + progress * total;
    if (self.pEndAngle > 360) {
        self.pEndAngle -= 360;
    }
    
    [self setNeedsDisplay];
}

- (void)setBackImg:(UIImage *)backImg {
    self.backImgView.image = backImg;
}

- (void)setCenterBtnImg:(UIImage *)img state:(UIControlState)state {
    [self.centerBtn setImage:img forState:state];
}

#pragma mark -- respondsTo

- (void)respondsToCenterBtn:(UIButton *)sender {
    if (self.callback) {
        self.callback(sender);
    }
}

#pragma mark -- set

- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
    self.roundView.startAngle = startAngle;
}

- (void)setEndAngle:(CGFloat)endAngle {
    _endAngle = endAngle;
    self.roundView.endAngle = endAngle;
}

#pragma mark -- get

- (UIImageView *)backImgView {
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _backImgView.image = [UIImage imageNamed:@"bathtub_back" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
    return _backImgView;
}

- (UIButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_centerBtn setImage:[UIImage imageNamed:@"bathtub_off" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [_centerBtn setImage:[UIImage imageNamed:@"bathtub_on" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        
        [_centerBtn addTarget:self action:@selector(respondsToCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

- (XQProgressRoundView *)roundView {
    if (!_roundView) {
        _roundView = [XQProgressRoundView new];
    }
    return _roundView;
}

- (UILabel *)minLab {
    if (!_minLab) {
        _minLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _minLab.textAlignment = NSTextAlignmentCenter;
        _minLab.text = @"MIN";
    }
    return _minLab;
}

- (UILabel *)maxLab {
    if (!_maxLab) {
        _maxLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _maxLab.textAlignment = NSTextAlignmentCenter;
        _maxLab.text = @"MAX";
    }
    return _maxLab;
}

@end























