//
//  RigisterViewController.m
//  easyTravel
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RigisterViewController.h"
#import "CommonUtil.h"
#import "AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "AppLogic.h"
#import "Toast+UIView.h"
#import "CommonUtil.h"
#import "MeDetailViewController.h"
#import "MyAccountViewController.h"
#import "ModifyPwdController.h"
#import "VipOrderViewController.h"
#import "MessageCenterViewController.h"
#import "ReserveViewController.h"
#import "VipViewController.h"
#import "Common.h"
#import "MainViewController.h"
#import "HotelSelectViewController.h"

@interface RigisterViewController (){
    UIButton *sendMsgBtn;
    NSTimer *timer;
    int theTime;
}
@end

@implementation RigisterViewController{
     NSArray *data;
    NSInteger code;
}
@synthesize tableView;
@synthesize confirmBtn;
@synthesize tipLabel;
@synthesize doneInKeyboardButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.hidesBottomBarWhenPushed=YES;
        // 下一个界面的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
        backButton.frame = CGRectMake(0.0, 0.0, 40.0, 27.0);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
    }
    return self;
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    code = -1;
    self.title = [CommonUtil getStrByKey:@"registerTitle"];
    [tableView registerNib:[UINib nibWithNibName:@"RegisterCell" bundle:nil] forCellReuseIdentifier:@"RegisterCell"];
    tableView.showsVerticalScrollIndicator=NO;
    data = [CommonUtil getArrayByKey:@"registerTitleArray"];
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    tableView.separatorStyle = NO;
    tableView.scrollEnabled = NO;
    
    
    confirmBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    confirmBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    confirmBtn.layer.borderWidth = 1.0f;
    confirmBtn.layer.cornerRadius = 3.0f;
    tipLabel.textColor = [CommonUtil getColor:@"555655"];
    [self configDoneInKeyBoardButton];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height+1;*/
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
    cell.text.tag = indexPath.row;
    cell.title.text = [data objectAtIndex:indexPath.row];
    cell.text.delegate = self;
    cell.delegate = self;
    if(indexPath.row==5){
        cell.sendMsgCodeBtn.hidden = NO;
    }else{
        cell.sendMsgCodeBtn.hidden = YES;
    }
    cell.text.returnKeyType = UIReturnKeyDone;
    switch (indexPath.row) {
        case 0:
        {
            //[cell.text becomeFirstResponder];
        }
            break;
        case 1:
        {
            cell.text.keyboardType = UIKeyboardTypeAlphabet;
            cell.text.secureTextEntry = YES;
        }
            break;
        case 2:
        {
            cell.text.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 3:
        {
            cell.text.keyboardType = UIKeyboardTypeAlphabet;
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            cell.text.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)confirm:(id)sender{
    RegisterCell *cell1 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RegisterCell *cell2 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RegisterCell *cell3 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    RegisterCell *cell4 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    RegisterCell *cell5 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    RegisterCell *cell6 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    if(cell1.text.text.length==0){
        [self.view makeToast:[CommonUtil getStrByKey:@"nameEmpty"] duration:1.0f position:@"center"];
        return;
    }
    if(![CommonUtil checkPassword:cell2.text.text]){
        [self.view makeToast:[CommonUtil getStrByKey:@"passwordError"] duration:1.0f position:@"center"];
        return;
    }
    
    if([cell3.text.text length]<=0){
        [self.view makeToast:[CommonUtil getStrByKey:@"telEmpty"] duration:1.0f position:@"center"];
        return;
    }
    
    
    if(![CommonUtil isMobileNumber:cell3.text.text]){
        [self.view makeToast:[CommonUtil getStrByKey:@"telError"] duration:1.0f position:@"center"];
        return;
    }
    
    if([cell4.text.text length]<=0){
        [self.view makeToast:[CommonUtil getStrByKey:@"personCodeEmpty"] duration:1.0f position:@"center"];
        return;
    }
    
    if(![CommonUtil checkUserIdCard:cell4.text.text]){
        [self.view makeToast:[CommonUtil getStrByKey:@"personCodeError"] duration:1.0f position:@"center"];
        return;
    }
    
    if(cell5.text.text.length==0){
        [self.view makeToast:[CommonUtil getStrByKey:@"addressError"] duration:1.0f position:@"center"];
        return;
    }
    
    /**/
    if(cell6.text.text.length==0){
        [self.view makeToast:[CommonUtil getStrByKey:@"msgCodeEmpty"] duration:1.0f position:@"center"];
        return;
    }
    
    if([cell6.text.text integerValue]!=code || code==-1){
        [self.view makeToast:[CommonUtil getStrByKey:@"shortMessageCodeError"] duration:1.0f position:@"center"];
        return;
    }
    
    [[AppLogic sharedInstance] checkPhone:cell3.text.text success:^(){
        NSDictionary *attributes = @{
                                     @"real_name":cell1.text.text,
                                     @"password":cell2.text.text,
                                     @"phone":cell3.text.text,
                                     @"user_card":cell4.text.text,
                                     @"receiving_address":cell5.text.text,
                                     };
        [[AppLogic sharedInstance] regist:attributes success:^(){
            [self.view makeToast:[CommonUtil getStrByKey:@"registerSuccess"] duration:1.5f position:@"center"];
            
            
            //[self.navigationController popToRootViewControllerAnimated:YES];
            
            
            switch ([AppLogic sharedInstance].loginSuccessWillGoViewTag) {
                case 0:
                    [self.navigationController pushViewController:[[MeDetailViewController alloc] initWithNibName:@"MeDetailViewController" bundle:nil] animated:YES];
                    break;
                case 1:
                    [self.navigationController pushViewController:[[MyAccountViewController alloc] initWithNibName:@"MyAccountViewController" bundle:nil] animated:YES];
                    break;
                case 3:
                    [self.navigationController pushViewController:[[ModifyPwdController alloc] initWithNibName:@"ModifyPwdController" bundle:nil] animated:YES];
                    break;
                case 4:
                    [self.navigationController pushViewController:[[VipOrderViewController alloc] initWithNibName:@"VipOrderViewController" bundle:nil] animated:YES];
                    break;
                case 5:
                    [self.navigationController pushViewController:[[MessageCenterViewController alloc] initWithNibName:@"MessageCenterViewController" bundle:nil] animated:YES];
                    break;
                case 6:
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                case 7:
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[VipViewController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                    break;
                case 999:
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[MainViewController class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                    break;
                case 8:
                    [self.navigationController pushViewController:[[HotelSelectViewController alloc] initWithNibName:@"HotelSelectViewController" bundle:nil] animated:YES];
                    break;
                default:
                    break;
            }
            
            
            
            
            
            
            
            
            
            
        } fail:^(NSString* message){
            [self.view makeToast:message duration:1.5f position:@"center"];
        }];
    } fail:^(NSString* message){
        [self.view makeToast:message duration:1.5f position:@"center"];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.keyboardType != UIKeyboardTypeNumberPad){
        doneInKeyboardButton.hidden = YES;
    }else{
        doneInKeyboardButton.hidden = NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    RegisterCell *cell1 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RegisterCell *cell2 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    RegisterCell *cell3 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    RegisterCell *cell4 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    RegisterCell *cell5 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    RegisterCell *cell6 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    if(cell1.text.isFirstResponder){
        [cell2.text becomeFirstResponder];
    }else if(cell2.text.isFirstResponder){
        [cell3.text becomeFirstResponder];
    }else if(cell3.text.isFirstResponder){
        [cell4.text becomeFirstResponder];
    }else if(cell4.text.isFirstResponder){
        [cell5.text becomeFirstResponder];
    }else if(cell5.text.isFirstResponder){
        [cell6.text becomeFirstResponder];
    }else if(cell6.text.isFirstResponder){
        [cell6.text resignFirstResponder];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(void)senMsg:(UIButton *)btn{
    sendMsgBtn = btn;
    NSString *text = sendMsgBtn.titleLabel.text;
    
    RegisterCell *cell3 = (RegisterCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if([cell3.text.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"phoneEmpty"]];
        return;
    }
    if(![CommonUtil isMobileNumber:cell3.text.text]){
        [self.view makeToast:[CommonUtil getStrByKey:@"telError"] duration:1.0f position:@"center"];
        return;
    }
    [[AppLogic sharedInstance] getRegistMsgCode:cell3.text.text success:^(NSInteger messageCode){
        //NSLog(@"获取成功___%d",messageCode);
        code = messageCode;
        if(timer==nil){
            theTime = 60;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countTime:) userInfo:nil repeats:YES];
        }else{
            //[self.view makeToast:[CommonUtil getStrByKey:@"msgCodeTimeIntervalTip"] duration:1.0f position:@"center"];
            return;
        }
    } fail:^(id message){
        [self.view makeToast:message duration:1.0f position:@"center"];
    }];

}

- (void)countTime:(NSTimer*)theTimer{
    theTime--;
    [sendMsgBtn setTitle:[NSString stringWithFormat:@"剩余%d秒",theTime] forState:UIControlStateNormal];
    if(theTime<=0){
        [timer invalidate];
        timer = nil;
        [sendMsgBtn setTitle:[CommonUtil getStrByKey:@"sendMsg"] forState:UIControlStateNormal];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(timer){
        [timer invalidate];
        timer = nil;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    //注销键盘显示通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [doneInKeyboardButton removeFromSuperview];
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewWillAppear:animated];
}

// 键盘出现处理事件
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘弹出的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // UIKeyboardAnimationCurveUserInfoKey 对应键盘弹出的动画类型
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [self configDoneInKeyBoardButton];
    //数字彩,数字键盘添加“完成”按钮
    if (doneInKeyboardButton){
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];//设置添加按钮的动画时间
        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
        //设置自定制按钮的添加位置(这里为数字键盘添加“完成”按钮)
        doneInKeyboardButton.transform=CGAffineTransformTranslate(doneInKeyboardButton.transform, 0, -53);
        [UIView commitAnimations];
    }
}

// 键盘消失处理事件
- (void)handleKeyboardWillHide:(NSNotification *)notification
{
    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
    NSDictionary *userInfo = [notification userInfo];
    // UIKeyboardAnimationDurationUserInfoKey 对应键盘收起的动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (doneInKeyboardButton.superview)
    {
        [UIView animateWithDuration:animationDuration animations:^{
            //动画内容，将自定制按钮移回初始位置
            doneInKeyboardButton.transform=CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            //动画结束后移除自定制的按钮
            //[doneInKeyboardButton removeFromSuperview];
        }];
        
    }
}

//初始化，数字键盘“完成”按钮
- (void)configDoneInKeyBoardButton{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //初始化
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneInKeyboardButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    //每次必须从新设定“完成”按钮的初始化坐标位置
    doneInKeyboardButton.frame = CGRectMake(0, screenHeight, 106, 53);
    
    //由于ios8下，键盘所在的window视图还没有初始化完成，调用在下一次 runloop 下获得键盘所在的window视图
    [self performSelector:@selector(addDoneButton) withObject:nil afterDelay:0.0f];
}

- (void) addDoneButton{
    //获得键盘所在的window视图
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    [tempWindow addSubview:doneInKeyboardButton];    // 注意这里直接加到window上
}
//点击“完成”按钮事件，收起键盘
-(void)finishAction{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
}

@end
