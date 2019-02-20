//
//  PinCode.m
//  easyTravel
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PinCode.h"

@implementation PinCode

@synthesize changeArray = _changeArray;
@synthesize changeString = _changeString;
@synthesize codeLabel = _codeLabel;



-(void)awakeFromNib{
    [self change];
    [self setNeedsDisplay];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor blueColor];
        
        [self change];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self change];
    [self setNeedsDisplay];
}

- (void)change
{
    self.changeArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
    
    NSMutableString *getStr = nil;
    
    self.changeString = [[NSMutableString alloc] initWithCapacity:6];
    for(NSInteger i = 0; i < 4; i++)
    {
        NSInteger index = arc4random() % ([self.changeArray count] - 1);
        getStr = [self.changeArray objectAtIndex:index];
        
        self.changeString = (NSMutableString *)[self.changeString stringByAppendingString:getStr];
    }
}
/*
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
    
    
    
    
}*/


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    [self setBackgroundColor:color];*/
    
    NSString *text = [NSString stringWithFormat:@"%@",self.changeString];
    CGSize cSize = [@"Ssss" sizeWithFont:[UIFont systemFontOfSize:40]];
    int width = rect.size.width/2-cSize.width/2;
    int height = rect.size.height/2-cSize.height/2;
    CGPoint point = CGPointMake(width, height);
    
    //CGContextSetCharacterSpacing(context, 10.0f);
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:40], NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName,[UIColor colorWithRed:0x5b/255.0f green:0x5b/255.0f blue:0x5b/255.0f alpha:1.0f],NSStrokeColorAttributeName,[NSNumber numberWithFloat:3.0f],NSStrokeWidthAttributeName,nil];
    [text drawAtPoint:point withAttributes:attrs];
    
    /*
    float pX, pY;
    for (int i = 0; i < text.length; i++)
    {
        pX = arc4random() % width + rect.size.width / text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        [textC drawAtPoint:point withFont:[UIFont systemFontOfSize:20]];
    }*/
    
    
    CGContextSetLineWidth(context, 1.0);
    
    
    /*
    for(int cout = 0; cout < 10; cout++)
    {
        red = arc4random() % 100 / 100.0;
        green = arc4random() % 100 / 100.0;
        blue = arc4random() % 100 / 100.0;
        color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        CGContextStrokePath(context);
    }*/
    
    
    
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

-(NSString*)getContent{
    return self.changeString;
}

@end
