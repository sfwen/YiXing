//
//  RedPoint.m
//  easyTravel
//
//  Created by apple on 15/7/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RedPoint.h"
#define PI 3.1415

@implementation RedPoint

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, 100, 20, 15, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}
@end
