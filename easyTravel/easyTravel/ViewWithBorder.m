//
//  ViewWithBorder.m
//  easyTravel
//
//  Created by apple on 15/7/17.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewWithBorder.h"

@implementation ViewWithBorder


-(void)drawRect:(CGRect)rect{
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f);//线条颜色
    
    
    
    //left
    CGContextMoveToPoint(context, 1, 0);
    CGContextAddLineToPoint(context,1,self.frame.size.height);
    CGContextStrokePath(context);
    
    //top
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context,self.frame.size.width,0);
    CGContextStrokePath(context);
    
    //right
    CGContextMoveToPoint(context,self.frame.size.width-1, 0);
    CGContextAddLineToPoint(context,self.frame.size.width-1,self.frame.size.height);
    CGContextStrokePath(context);
    
    //bottom
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height);
    CGContextStrokePath(context);
    
    
    
    
}
@end
