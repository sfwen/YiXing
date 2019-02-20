//
//  RedNumberView.m
//  easyTravel
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RedNumberView.h"
#import "CommonUtil.h"

@implementation RedNumberView

@synthesize label;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    label = [[UILabel alloc] initWithFrame:CGRectMake(2,2, 5, 5)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:8.0f];
    [self addSubview:label];
}


-(void)setNum:(int)num{
    label.text = [NSString stringWithFormat:@"%d",num];
    //[label setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, [CommonUtil getColor:@"ff0000"].CGColor);
    CGContextFillPath(ctx);
    
}

@end
