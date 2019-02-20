//
//  CustomTextField.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)drawRect:(CGRect)rect {
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0x72/255.0f, 0xb5/255.0f, 0xc5/255.0f, 0xff/255.0f);//线条颜色
    //left
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,0,self.frame.size.height);
    CGContextStrokePath(context);
    
    //right
    CGContextMoveToPoint(context,self.frame.size.width,0);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height);
    CGContextStrokePath(context);
    
    //bottom
    CGContextMoveToPoint(context, 0, self.frame.size.height);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height);
    CGContextStrokePath(context);

}

@end
