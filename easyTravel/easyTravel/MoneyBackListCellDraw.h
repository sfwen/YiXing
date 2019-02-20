//
//  CellDraw.h
//  easyTravel
//
//  Created by apple on 15/7/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyBackListCellDraw : UIView

@property(copy,nonatomic)NSString *text1;
@property(copy,nonatomic)NSString *text2;
@property(copy,nonatomic)NSString *text3;


- (id)initWithFrame:(CGRect)frame:(NSString*)text1:(NSString*)text2:(NSString*)text3;
@end
