//
//  CommentViewController.m
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CommentViewController.h"
#import "CommonUtil.h"
#import "Toast+UIView.h"
#import "AppLogic.h"
#import "AddImageView.h"
#import "Common.h"
#import "UIImageView+AFNetworking.h"
#import "NSString+Extension.h"
#import "VipOrderViewController.h"
#import "CommonUtil.h"
#import "CustomAlertView.h"
#import "JKAlertDialog.h"

@interface CommentViewController (){
    NSArray *imageArray;
    UIImagePickerController *imagePicker;
    int currentImageTag;
    NSMutableArray *imageDataArray;
    
}
@end

@implementation CommentViewController

@synthesize content;
@synthesize tip;
@synthesize submit;
@synthesize image;
@synthesize commentTitle;
@synthesize dateLabel;
@synthesize rmbLabel;
@synthesize date;
@synthesize rmb;
@synthesize order_id;
@synthesize goods_id;
@synthesize image1;
@synthesize image2;
@synthesize goods_image;
@synthesize image3;
@synthesize goods_name;
@synthesize goods_price;
@synthesize goods_time;

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
    imageDataArray = [[NSMutableArray alloc] init];
    self.title=[CommonUtil getStrByKey:@"commentTitle"];
    currentImageTag = 0;
    image1.tag = 0;
    image2.tag = 1;
    image3.tag = 2;
    image1.delegate = self;
    image2.delegate = self;
    image3.delegate = self;
    image2.hidden = YES;
    image3.hidden = YES;
    imageArray = @[image1,image2,image3];
    content.layer.borderColor = [CommonUtil getColor:@"dcdcdc"].CGColor;
    content.layer.borderWidth = 1;
    content.delegate = self;
    content.returnKeyType = UIReturnKeyDone;
    tip.textColor = [CommonUtil getColor:@"dcdcdc"];
    submit.layer.borderColor = [CommonUtil getColor:@"0bc0f4"].CGColor;
    submit.backgroundColor = [CommonUtil getColor:@"0bc0f4"];
    submit.layer.borderWidth = 1.0f;
    submit.layer.cornerRadius = 3.0f;
    rmb.textColor = [CommonUtil getColor:@"fd682b"];
    // Do any additional setup after loading the view from its nib.
    [image setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,goods_image]] placeholderImage:[UIImage imageNamed:@"image.jpg"]];
    date.text = goods_time;
    rmb.text = [NSString stringWithFormat:@"￥%@",goods_price];
    commentTitle.text = goods_name;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)doSubmit:(id)sender {
    /*
    if(content.text.length<=0){
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"commentContentEmpty"]];
        return;
    }*/
    NSDictionary *attributes = @{
                                 @"ucode":[AppLogic sharedInstance].ucode,
                                 @"order_id":order_id,
                                 @"goods_id":goods_id,
                                 @"content":[NSString encodeURL:content.text],
                                 };
    
    [[AppLogic sharedInstance] addComment:([imageDataArray count]>=1 ? [imageDataArray objectAtIndex:0] :nil) :([imageDataArray count]>=2 ?[imageDataArray objectAtIndex:1]:nil) :([imageDataArray count]>=3 ? [imageDataArray objectAtIndex:2] : nil) :attributes success:^{
        [[AppLogic sharedInstance] makeToast:[CommonUtil getStrByKey:@"submitCommentSuccess"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"commentSuccess" object:nil];
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[VipOrderViewController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    } fail:^(NSString *message) {
        [[AppLogic sharedInstance] makeToast:message];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePicker dismissModalViewControllerAnimated:YES];
}

-(void)addImage:(int)tag{
    currentImageTag = tag;
    
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"上传评论图片"
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"本地选择",@"取消",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
    
    
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"上传评论图片" contentText:@"" leftButtonTitle:@"拍照" rightButtonTitle:@"本地上传"];
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
    
    
    JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"" message:@"上传评论图片"];
    [alert addButton:Button_OTHER withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
    }];;
    /*
    [alert addButton:Button_OTHER withTitle:@"拍照" handler:^(JKAlertDialogItem *item) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }];*/
    
    [alert addButton:Button_OTHER withTitle:@"本地上传" handler:^(JKAlertDialogItem *item) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];
    }];
    [alert show];
    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [imagePicker dismissModalViewControllerAnimated:YES];
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    AddImageView *addImageView = [imageArray objectAtIndex:currentImageTag];
    addImageView.imageView.image = image;
    addImageView.imageView.hidden = NO;
    addImageView.closeBtn.hidden = NO;
    NSData *imageData = UIImageJPEGRepresentation(image,0.3);
    [imageDataArray addObject:imageData];
    switch (currentImageTag) {
        case 0:
        {
            image2.hidden = NO;
            image2.imageView.image = nil;
        }
            break;
        case 1:
        {
            image3.hidden = NO;
            image3.imageView.image = nil;
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    
}

-(void)deleteImage:(int)tag{
    
    AddImageView *addImageView = [imageArray objectAtIndex:tag];
    addImageView.imageView.image = [UIImage imageNamed:@""];
    addImageView.imageView.hidden = YES;
    addImageView.closeBtn.hidden = YES;
    
    [imageDataArray removeObjectAtIndex:tag];
    
    
    if([imageDataArray count]==0){
        image1.hidden=NO;
        image2.hidden=YES;
        image3.hidden=YES;
    }else if([imageDataArray count]==1){
        image1.hidden=NO;
        image2.hidden=NO;
        image3.hidden=YES;
        image1.imageView.image = [UIImage imageWithData:[imageDataArray objectAtIndex:0]];
        image1.imageView.hidden = NO;
        image1.closeBtn.hidden = NO;
        
        image2.imageView.image = nil;
        image2.imageView.hidden = YES;
        image2.closeBtn.hidden = YES;
    }else if([imageDataArray count]==2){
        image1.hidden=NO;
        image2.hidden=NO;
        image3.hidden=NO;
        
        image1.imageView.image = [UIImage imageWithData:[imageDataArray objectAtIndex:0]];
        image1.imageView.hidden = NO;
        image1.closeBtn.hidden = NO;
        
        image2.imageView.image = [UIImage imageWithData:[imageDataArray objectAtIndex:1]];
        image2.imageView.hidden = NO;
        image2.closeBtn.hidden = NO;
        
        image3.imageView.image = nil;
        image3.imageView.hidden = YES;
        image3.closeBtn.hidden = YES;
        
        
    }else{
        image1.hidden=NO;
        image2.hidden=NO;
        image3.hidden=NO;
        
        image1.imageView.image = [UIImage imageWithData:[imageDataArray objectAtIndex:0]];
        image1.imageView.hidden = NO;
        image1.closeBtn.hidden = NO;
        
        image2.imageView.image = [UIImage imageWithData:[imageDataArray objectAtIndex:1]];
        image2.imageView.hidden = NO;
        image2.closeBtn.hidden = NO;
        
        image3.imageView.image = [UIImage imageWithData:[imageDataArray objectAtIndex:1]];
        image3.imageView.hidden = NO;
        image3.closeBtn.hidden = NO;
    }
}

@end
