//
//  CellDraw.m
//  easyTravel
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MoneyBackListCellDraw.h"
#import "CommonUtil.h"

@implementation MoneyBackListCellDraw

@synthesize text1;
@synthesize text2;
@synthesize text3;

- (id)initWithFrame:(CGRect)frame:(NSString*)text1:(NSString*)text2:(NSString*)text3{
    
    if (self = [super initWithFrame:frame]) {
        self.text1 = text1;
        self.text2 = text2;
        self.text3 = text3;
    }
    //self.backgroundColor = [UIColor clearColor];
    return self;
    
}


-(void)drawRect:(CGRect)rect{
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f);//线条颜色
    
    /**/
    //left
    CGContextMoveToPoint(context, 1, 0);
    CGContextAddLineToPoint(context,1,self.frame.size.height/2);
    CGContextStrokePath(context);
    
    //top
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context,self.frame.size.width,0);
    CGContextStrokePath(context);
    
    //right
    CGContextMoveToPoint(context,self.frame.size.width-1, 0);
    CGContextAddLineToPoint(context,self.frame.size.width-1,self.frame.size.height/2);
    CGContextStrokePath(context);
    
    //bottom
    CGContextMoveToPoint(context, 0, self.frame.size.height/2);
    CGContextAddLineToPoint(context,self.frame.size.width,self.frame.size.height/2);
    CGContextStrokePath(context);
    
    //两条横线
    CGContextMoveToPoint(context, self.frame.size.width/3.0f, 0);
    CGContextAddLineToPoint(context,self.frame.size.width/3.0f,self.frame.size.height/2);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 2*self.frame.size.width/3.0f, 0);
    CGContextAddLineToPoint(context,2*self.frame.size.width/3.0f,self.frame.size.height/2);
    CGContextStrokePath(context);
    
    //字体设置
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName,style,NSParagraphStyleAttributeName,[CommonUtil getColor:@"333333"],NSForegroundColorAttributeName,nil];
    
    
    [self.text1 drawInRect:CGRectMake(0, 18, self.frame.size.width/3.0f, self.frame.size.height) withAttributes:attrs];
    [self.text2 drawInRect:CGRectMake(self.frame.size.width/3.0f, 18, self.frame.size.width/3.0f, self.frame.size.height) withAttributes:attrs];
    [self.text3 drawInRect:CGRectMake(2*self.frame.size.width/3.0f, 18, self.frame.size.width/3.0f, self.frame.size.height) withAttributes:attrs];

}

@end
