//
//  AddImageView.m
//  easyTravel
//
//  Created by apple on 15/7/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddImageView.h"

@implementation AddImageView

@synthesize delegate;
@synthesize imageView;
@synthesize closeBtn;

-(id)initWithCoder:(NSCoder *)coder{
    id obj = [super initWithCoder:coder];
    return obj;
}

-(void)awakeFromNib{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(add:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:@""];
    
    closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-16,0, 16, 16)];
    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateSelected];
    [closeBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:closeBtn];
    
    closeBtn.hidden = YES;
    
}

-(void)delete:(UIButton *)button{
    if([delegate respondsToSelector:@selector(deleteImage:)]){
        [delegate deleteImage:(int)self.tag];
    }
}


-(void)add:(UITapGestureRecognizer *)sender{
    if([delegate respondsToSelector:@selector(addImage:)]){
        [delegate addImage:(int)self.tag];
    }
}


-(void)drawRect:(CGRect)rect{
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(context, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f, 0xdc/255.0f);//线条颜色
    
    
    CGContextSetLineWidth(context, 3.0f);
    CGContextMoveToPoint(context,self.frame.size.width/4, self.frame.size.height/2);
    CGContextAddLineToPoint(context,3*self.frame.size.width/4, self.frame.size.height/2);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 3.0f);
    CGContextMoveToPoint(context,self.frame.size.width/2, self.frame.size.height/4);
    CGContextAddLineToPoint(context,self.frame.size.width/2, 3*self.frame.size.height/4);
    CGContextStrokePath(context);
    
    
    CGFloat lengths[] = {5,5,5,5};
    CGContextSetLineDash(context, 0, lengths, 4);
    
    
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
