//
//  MeDetailViewController.m
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MeDetailViewController.h"
#import "CommonUtil.h"
#import "MeDetailTableViewCell.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "UIImageView+AFNetworking.h"
#import "CustomAlertView.h"
#import "JKAlertDialog.h"
#import "LevelUpViewController.h"

enum TABLEMODE{
    TABLE_TYPE_DISPLAY = 0,
    TABLE_TYPE_EDIT = 1
};

@interface MeDetailViewController (){
    enum TABLEMODE tMode;
    NSArray *titleArray;
    NSDictionary *info;
    NSMutableArray *dataDictionary;
    NSTimeInterval birthDay;
    UIImagePickerController *imagePicker;
    NSData *imageData;
    UITextField *currentTextField;
}
@end

@implementation MeDetailViewController

@synthesize editBtn;
@synthesize line1;
@synthesize line2;
@synthesize tableView;
@synthesize nameLabel;
@synthesize head;
@synthesize levelUpBtn;
@synthesize vipImageView;

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
    
    head.layer.masksToBounds =YES;
    head.layer.cornerRadius =35;
    
    self.view.userInteractionEnabled = YES;
    // Do any additional setup after loading the view from its nib.
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",IMAGE_HOST,[AppLogic sharedInstance].head_img];
    [head setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"head.jpg"]];
    
    dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setValue:@"" forKey:@"0"];
    [dataDictionary setValue:@"" forKey:@"1"];
    [dataDictionary setValue:@"" forKey:@"2"];
    [dataDictionary setValue:@"" forKey:@"3"];
    [dataDictionary setValue:@"" forKey:@"4"];
    [dataDictionary setValue:@"" forKey:@"5"];
    [dataDictionary setValue:@"" forKey:@"6"];
    [dataDictionary setValue:@"" forKey:@"7"];
    [dataDictionary setValue:@"" forKey:@"8"];
    [dataDictionary setValue:@"" forKey:@"9"];
    self.title = [CommonUtil getStrByKey:@"meDetailTitle"];
    editBtn = [[UIBarButtonItem alloc] initWithTitle:[CommonUtil getStrByKey:@"edit"] style:UIBarButtonItemStyleDone target:self action:@selector(doEdit:)];
    editBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = editBtn;
    line1.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    line2.backgroundColor = [CommonUtil getColor:@"dcdcdc"];
    self.view.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    tableView.backgroundColor = [CommonUtil getColor:@"f8f8f8"];
    tableView.separatorStyle = NO;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = NO;
    titleArray = [CommonUtil getArrayByKey:@"meDetailTitleArray"];
    
    
    
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 };
    [[AppLogic sharedInstance] getUserInfo:attributes success:^(NSDictionary *personInfo) {
        info = personInfo;
        nameLabel.text = [info valueForKeyPath:@"real_name"];
        [self setAccountRelatedBtnInfo];
        [dataDictionary setValue:([info valueForKeyPath:@"ucard_number"]!=nil?[info valueForKeyPath:@"ucard_number"]:@"") forKey:@"0"];
        [dataDictionary setValue:([info valueForKeyPath:@"real_name"]!=nil?[info valueForKeyPath:@"real_name"]:@"") forKey:@"1"];
        [dataDictionary setValue:([info valueForKeyPath:@"sex"]!=nil?[info valueForKeyPath:@"sex"]:@"") forKey:@"2"];
        [dataDictionary setValue:[info valueForKeyPath:@"user_card"] forKey:@"3"];
        [dataDictionary setValue:([[AppLogic sharedInstance].userInfo valueForKeyPath:@"phone"]!=nil?[[AppLogic sharedInstance].userInfo valueForKeyPath:@"phone"]:@"") forKey:@"4"];
        [dataDictionary setValue:([info valueForKeyPath:@"email"]!=nil?[info valueForKeyPath:@"email"]:@"") forKey:@"5"];
        [dataDictionary setValue:([info valueForKeyPath:@"qq"]!=nil?[info valueForKeyPath:@"qq"]:@"") forKey:@"6"];
        [dataDictionary setValue:([info valueForKeyPath:@"msn"]!=nil?[info valueForKeyPath:@"msn"]:@"") forKey:@"7"];
        [dataDictionary setValue:([info valueForKeyPath:@"birthday"]!=nil ?[info valueForKeyPath:@"birthday"]:@"") forKey:@"8"];
        birthDay = [[info valueForKeyPath:@"birthday"] doubleValue];
        [dataDictionary setValue:([info valueForKeyPath:@"receiving_address"]!=nil?[info valueForKeyPath:@"receiving_address"]:@"") forKey:@"9"];
        
        
        [tableView reloadData];
        
        head.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHead:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.delegate = self;
        [head addGestureRecognizer:tapGesture];
        
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)tapHead:(UITapGestureRecognizer *)sender{
    if(tMode==TABLE_TYPE_EDIT){
        
        
        /*
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];*/
        
        /*
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"修改头像"
                                      delegate:self
                                      cancelButtonTitle:nil
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"拍照", @"本地选择",@"取消",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];*/
        
        /*
        UIAlertController  *alertController = [UIAlertController alertControllerWithTitle:@"修改头像"
                                                                                  message:@""
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction  *alertAction = [UIAlertAction actionWithTitle:@"拍照"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 //Do ur stuff
                                                                 [alertController dismissViewControllerAnimated:YES
                                                                                                     completion:NULL];
                                                                 imagePicker = [[UIImagePickerController alloc] init];
                                                                 imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                 imagePicker.delegate = self;
                                                                 [self presentModalViewController:imagePicker animated:YES];
                                                             }];
        
        UIAlertAction  *alertAction2 = [UIAlertAction actionWithTitle:@"本地选择"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 //Do ur stuff
                                                                 [alertController dismissViewControllerAnimated:YES
                                                                                                     completion:NULL];
                                                                 imagePicker = [[UIImagePickerController alloc] init];
                                                                 imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                 imagePicker.delegate = self;
                                                                 [self presentModalViewController:imagePicker animated:YES];
                                                             }];

        [alertController addAction:alertAction];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController
                           animated:YES
                         completion:NULL];*/
        
        /*
        UIAlertView *delAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"删除联系人？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [delAlert show];*/
        
        /*
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"修改头像" contentText:@"" leftButtonTitle:@"拍照" rightButtonTitle:@"本地上传"];
        [alert show];
        alert.leftBlock = ^() {
            //NSLog(@"取消");
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        };
        alert.rightBlock = ^() {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        };*/
        
        
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"" message:@"修改头像"];
        [alert addButton:Button_OTHER withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
        }];;
        
        [alert addButton:Button_OTHER withTitle:@"拍照" handler:^(JKAlertDialogItem *item) {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        }];
        
        [alert addButton:Button_OTHER withTitle:@"本地上传" handler:^(JKAlertDialogItem *item) {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentModalViewController:imagePicker animated:YES];
        }];
        [alert show];

        
        
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%d",buttonIndex);
    if(buttonIndex==0){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }
    if(buttonIndex==1){
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePicker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [imagePicker dismissModalViewControllerAnimated:YES];
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    imageData = UIImageJPEGRepresentation(image,0.3);
    head.image = image;
   
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}


- (void)doEdit:(id)sender{
    if(tMode==TABLE_TYPE_DISPLAY){
        tMode = TABLE_TYPE_EDIT;
        editBtn.title = @"完成";
        [tableView reloadData];
    }else{
        //submiit to server
        [dataDictionary setValue:currentTextField.text forKey:[NSString stringWithFormat:@"%d",(int)currentTextField.tag]];
        if(![CommonUtil checkUserIdCard:[dataDictionary valueForKey:@"3"]]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"personCodeError"]];
            return;
        }
        /*
        if(![CommonUtil isMobileNumber:[dataDictionary valueForKey:@"4"]]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"telError"]];
            return;
        }*/
        if([[dataDictionary valueForKey:@"5"] length]>0 && ![CommonUtil isValidateEmail:[dataDictionary valueForKey:@"5"]]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"emailError"]];
            return;
        }
        if([[dataDictionary valueForKey:@"6"] length]>0 && ![CommonUtil checkQQ:[dataDictionary valueForKey:@"6"]]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"qqError"]];
            return;
        }
        if([[dataDictionary valueForKey:@"7"] length]>0 && ![CommonUtil isValidateEmail:[dataDictionary valueForKey:@"7"]]){
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"msnError"]];
            return;
        }
        NSDictionary *attributes = @{
                                     @"ucode":[AppLogic sharedInstance].ucode,
                                     @"real_name":[dataDictionary valueForKey:@"1"],
                                     @"sex":[dataDictionary valueForKey:@"2"],
                                     @"email":[dataDictionary valueForKey:@"5"],
                                     @"birthday":[NSNumber numberWithDouble:birthDay],
                                     @"user_card":[dataDictionary valueForKey:@"3"],
                                     @"qq":[dataDictionary valueForKey:@"6"],
                                     @"msn":[dataDictionary valueForKey:@"7"],
                                     @"tel":[dataDictionary valueForKey:@"4"],
                                     @"receiving_address":[dataDictionary valueForKey:@"9"],
                                     };
        [[AppLogic sharedInstance] updateUserInfo:imageData :attributes success:^{
            tMode = TABLE_TYPE_DISPLAY;
            editBtn.title = [CommonUtil getStrByKey:@"edit"];
            [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"updateSuccess"]];
            [tableView reloadData];
            
            NSDictionary *attributes = @{
                                         @"ucode":[AppLogic sharedInstance].ucode,
                                         };
            [[AppLogic sharedInstance] getUserInfo:attributes success:^(NSDictionary *personInfo) {
                info = personInfo;
                nameLabel.text = [info valueForKeyPath:@"real_name"];
                //[AppLogic sharedInstance].userInfo = personInfo;
                [AppLogic sharedInstance].real_name = [info valueForKeyPath:@"real_name"];
                [AppLogic sharedInstance].head_img = [info valueForKeyPath:@"head_img"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
                
            } fail:^(NSString *message) {
                [[AppLogic sharedInstance] makeToast:message];
            }];
            
            
            
        } fail:^(NSString *message) {
            [[AppLogic sharedInstance] makeToast:message];
        }];
        
        
        
        
        for(int i=0;i<[titleArray count];i++){
            MeDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.content.enabled=NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"MeDetailTableViewCell";
    MeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MeDetailTableViewCell" owner:self options:NULL][0];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.content.delegate = self;
    cell.content.tag = indexPath.row;
    
    if(tMode==TABLE_TYPE_DISPLAY){
        cell.content.enabled = NO;
    }else{
        cell.content.enabled = YES;
        if(indexPath.row==2){
            [cell displayCheckBox];
        }else{
            [cell hideCheckBox];
        }
        if(indexPath.row==0 || indexPath.row==4){
            cell.content.enabled = NO;
        }
    }
    
    cell.title.text=[titleArray objectAtIndex:indexPath.row];
    [cell updateData:dataDictionary :(int)indexPath.row];
    
    cell.content.returnKeyType = UIReturnKeyDone;
    switch (indexPath.row) {
        case 3:
        {
            cell.content.keyboardType = UIKeyboardTypeAlphabet;
        }
            break;
        case 4:
        {
            cell.content.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 5:
        {
            cell.content.keyboardType = UIKeyboardTypeAlphabet;
        }
            break;
        case 6:
        {
            cell.content.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
            
        case 8:{
            cell.content.enabled = NO;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [formatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:birthDay]];
            cell.content.text = dateString;
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tMode==TABLE_TYPE_DISPLAY){
        return;
    }
    if(indexPath.row==8){
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        SelectDateViewController *dateViewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
        dateViewController.mode = 0;
        dateViewController.delegate = self;
        [self.navigationController pushViewController:dateViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    [dataDictionary setValue:textField.text forKey:[NSString stringWithFormat:@"%d",(int)textField.tag]];
    if(textField.tag==8){
        /*
        SelectDateViewController *dateViewController = [[SelectDateViewController alloc] initWithNibName:@"SelectDateViewController" bundle:nil];
        dateViewController.mode = 0;
        dateViewController.delegate = self;
        [self.navigationController pushViewController:dateViewController animated:YES];
        [textField resignFirstResponder];*/
        //[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }else{
        if(textField.tag>=3){
            [UIView animateWithDuration:0.5f animations:^{
                tableView.center = CGPointMake(tableView.center.x,tableView.center.y-250);
            }];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag!=2){
        [dataDictionary setValue:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
    }
    if(textField.tag>=3&&textField.tag!=8){
        [UIView animateWithDuration:0.5f animations:^{
            tableView.center = CGPointMake(tableView.center.x,tableView.center.y+250);
        }];
    }
}

-(void)selectDate:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    birthDay = [[formatter dateFromString:dateStr] timeIntervalSince1970];
    [tableView reloadData];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [dataDictionary setValue:textField.text forKey:[NSString stringWithFormat:@"%d",(int)textField.tag]];
    return YES;
}

-(void)updateSex:(NSString *)sexStr{
    [dataDictionary setValue:sexStr forKey:@"2"];
}

- (IBAction)levelUp1:(id)sender {
    [self toLevelUpView];
}

- (IBAction)levelUp2:(id)sender {
    [self toLevelUpView];
}

-(void)toLevelUpView{
    if([AppLogic sharedInstance].vipFlag==3){//砖石会员
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"isMostVip"]];
        return;
    }
    LevelUpViewController *levelUpViewController = [[LevelUpViewController alloc] initWithNibName:@"LevelUpViewController" bundle:nil];
    [self.navigationController pushViewController:levelUpViewController animated:YES];
}

-(void)setAccountRelatedBtnInfo{
    //[AppLogic sharedInstance].vipFlag=2;
    if([AppLogic sharedInstance].vipFlag==1){//vip会员
        [vipImageView setImage:[UIImage imageNamed:@"v2.png"] forState:UIControlStateNormal];
        [levelUpBtn setTitle:[CommonUtil getStrByKey:@"v2Name"] forState:UIControlStateNormal];
    }else if([AppLogic sharedInstance].vipFlag==2){//普通用户
        [vipImageView setImage:[UIImage imageNamed:@"vipIcon.png"] forState:UIControlStateNormal];
        [levelUpBtn setTitle:[CommonUtil getStrByKey:@"levelUp"] forState:UIControlStateNormal];
    }else if([AppLogic sharedInstance].vipFlag==3){//砖石会员
        [vipImageView setImage:[UIImage imageNamed:@"v3.png"] forState:UIControlStateNormal];
        [levelUpBtn setTitle:[CommonUtil getStrByKey:@"v3Name"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setAccountRelatedBtnInfo];
}

@end
