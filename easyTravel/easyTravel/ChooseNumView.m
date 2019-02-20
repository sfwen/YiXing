//
//  ChooseNumView.m
//  test
//
//  Created by cg on 15/11/6.
//  Copyright © 2015年 forgame. All rights reserved.
//

#import "ChooseNumView.h"
#import "CommonUtil.h"

@implementation ChooseNumView


-(id)init{
    self=[super init];
    if(self){
        self.backgroundColor = [CommonUtil getColor:@"ccffff"];
        _isShow = NO;
        self.frame = CGRectMake(0,-220,[UIScreen mainScreen].bounds.size.width,200);
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,0, 320, 200)];
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
        
        
        UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,60)];
        titleBgView.backgroundColor = [UIColor grayColor];
        [self addSubview:titleBgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 30)];
        label.text=@"请选择人数";
        [self addSubview:label];
        
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-60, 15, 60, 30)];
        //_doneBtn.backgroundColor=[UIColor redColor];
        //[_doneBtn setTintColor:[UIColor blackColor]];
        [_doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(doneBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_doneBtn];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}


-(void)show{
    if(_isShow){
        return;
    }
    _isShow = YES;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, 100,self.frame.size.width, self.frame.size.height);
    }];
}

-(void)hide{
    if(!_isShow){
        return;
    }
    _isShow = NO;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, -220,self.frame.size.width, self.frame.size.height);
    }];
}

-(void)doneBtnClick:(UIButton*)sender{
    int row = (int)([_pickerView selectedRowInComponent:0]+1);
    if([_delegate respondsToSelector:@selector(chooseNumber:)]){
        [_delegate chooseNumber:row];
    }
    [self hide];
}



// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (component == 1) {
        return 40;
    }
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d",(int)(row+1)];
}



@end
