//
//  PinCode.h
//  easyTravel
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinCode : UIView

@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;


-(void)change;
-(NSString*)getContent;

@end
