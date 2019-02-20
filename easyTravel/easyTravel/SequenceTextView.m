//
//  RedNumberView.m
//  easyTravel
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SequenceTextView.h"
#import "CommonUtil.h"

@implementation SequenceTextView

@synthesize sequence;
@synthesize title;
@synthesize numBg;

-(void)awakeFromNib{
    self.backgroundColor = [UIColor clearColor];
    sequence = [[UILabel alloc] initWithFrame:CGRectMake(3,2,10,10)];
    sequence.textColor = [UIColor whiteColor];
    sequence.textAlignment = NSTextAlignmentCenter;
    sequence.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:sequence];
    title = [[UILabel alloc] initWithFrame:CGRectMake(20,-20,140,60)];
    title.numberOfLines = 2;
    title.textColor = [CommonUtil getColor:@"333433"];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:title];
}


-(void)setSequence:(int)seq:(NSString*)text:(NSString*)noBg{
    self.sequence.text = [NSString stringWithFormat:@"%d",seq];
    self.title.text = text;
    self.numBg = noBg;
    CGSize size =[text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    if(size.width>145.0f){
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y+5, title.frame.size.width, title.frame.size.height);
    }else{
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y+12, title.frame.size.width, title.frame.size.height/2);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0,0,16,16));
    CGContextSetFillColorWithColor(ctx, [CommonUtil getColor:self.numBg].CGColor);
    CGContextFillPath(ctx);
    
}

@end
