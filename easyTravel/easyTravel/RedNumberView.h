//
//  RedNumberView.h
//  easyTravel
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedNumberView : UIView


@property(strong,nonatomic) UILabel *label;

-(void)setNum:(int)num;
@end
