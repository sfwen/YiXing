//
//  ModifyPwdController.m
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ModifyPwdController.h"
#import "CommonUtil.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "CellDraw.h"
#import "CommonUtil.h"

@interface ModifyPwdController (){

    NSArray *titleArray;
}
@end

@implementation ModifyPwdController

@synthesize submitBtn;
@synthesize tableView;

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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    titleArray = [CommonUtil getArrayByKey:@"modifyPwdTitleArray"];
    [tableView registerNib:[UINib nibWithNibName:@"ModifyPwdCell" bundle:nil] forCellReuseIdentifier:@"ModifyPwdCell"];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.navigationController.navigationBar.barTintColor = [CommonUtil getNavigationBarBgColor];
    self.title = [CommonUtil getStrByKey:@"modifyPwdTitle"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [CommonUtil getColor:@"ffffff"],UITextAttributeTextColor,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     
                                                                     
                                                                     nil]];
    
    submitBtn.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    submitBtn.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    submitBtn.layer.borderWidth = 1.0f;
    submitBtn.layer.cornerRadius = 6.0f;
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    //tableView.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    tableView.separatorStyle = NO;
    tableView.scrollEnabled = NO;
    
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

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




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ModifyPwdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModifyPwdCell"];
    cell.cellTitle.text = [titleArray objectAtIndex:indexPath.row];
    cell.cellTextField.delegate = self;
    cell.cellTextField.secureTextEntry = YES;
    if(indexPath.row==0){
        [cell.cellTextField becomeFirstResponder];
    }
    if(indexPath.row==2){
        cell.cellTextField.returnKeyType = UIReturnKeyDone;
    }else{
        cell.cellTextField.returnKeyType = UIReturnKeyNext;
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    ModifyPwdCell *cell1 = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ModifyPwdCell *cell2 = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ModifyPwdCell *cell3 = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    if(cell1.cellTextField.isFirstResponder){
        [cell2.cellTextField becomeFirstResponder];
    }else if(cell2.cellTextField.isFirstResponder){
        [cell3.cellTextField becomeFirstResponder];
    }else if(cell3.cellTextField.isFirstResponder){
        [cell3 resignFirstResponder];
    }
    return YES;
}


- (IBAction)submit:(id)sender {
    ModifyPwdCell *cell1 = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ModifyPwdCell *cell2 = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ModifyPwdCell *cell3 = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    
    /*
    if(![CommonUtil checkPassword:cell1.cellTextField.text]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"oldPasswordError"]];
        return;
    }*/
    
    if([cell1.cellTextField.text length]<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"oldPasswordEmpty"]];
        return;
    }
    
    if(![CommonUtil checkPassword:cell2.cellTextField.text]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"newPasswordError"]];
        return;
    }
    if(![cell3.cellTextField.text isEqualToString:cell2.cellTextField.text]){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"passwordNotSameError"]];
        return;
    }
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"password":cell2.cellTextField.text,
                                 @"oldpassword":cell1.cellTextField.text,
                                };
    [[AppLogic sharedInstance] modifyPassword:attributes success:^{
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"modifyPwdSuccess"]];
        //[[NSUserDefaults standardUserDefaults] setObject:cell2.cellTextField.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)modifyCellTouch:(int)tag{
    ModifyPwdCell *cell = (ModifyPwdCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    [cell.cellTextField becomeFirstResponder];
}

@end
