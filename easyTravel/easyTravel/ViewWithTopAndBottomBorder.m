//
//  VipOrderTopIconContainer.m
//  easyTravel
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewWithTopAndBottomBorder.h"

@implementation ViewWithTopAndBottomBorder

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect{
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f);//线条颜色
    
    //top
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context,self.frame.size.width,0);
    CGContextStrokePath(context);
    
    //bottom
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height);
    CGContextStrokePath(context);
    
    
}

@end
