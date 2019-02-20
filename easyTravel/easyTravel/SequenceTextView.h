//
//  RedNumberView.h
//  easyTravel
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SequenceTextView : UIView


@property(strong,nonatomic) UILabel *sequence;
@property(strong,nonatomic) UILabel *title;
@property(copy,nonatomic)NSString *numBg;

-(void)setSequence:(int)seq:(NSString*)text:(NSString*)noBg;
@end
