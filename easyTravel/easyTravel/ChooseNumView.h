//
//  ChooseNumView.h
//  test
//
//  Created by cg on 15/11/6.
//  Copyright © 2015年 forgame. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseNumDelegate <NSObject>

-(void)chooseNumber:(int)number;
@end

@interface ChooseNumView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>


@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIButton *doneBtn;

@property(nonatomic,assign)id<ChooseNumDelegate> delegate;

-(void)show;
-(void)hide;
@property(nonatomic,assign)BOOL isShow;

@end
