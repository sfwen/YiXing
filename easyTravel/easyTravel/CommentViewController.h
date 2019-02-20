//
//  CommentViewController.h
//  easyTravel
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddImageView.h"
#import "BaseViewController.h"

@interface CommentViewController : BaseViewController<UITextViewDelegate,SelectPhotosDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *tip;
@property (weak, nonatomic) IBOutlet UIButton *submit;
- (IBAction)doSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *commentTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *rmb;


@property(strong,nonatomic) NSString *order_id;
@property(strong,nonatomic) NSString *goods_id;
@property(strong,nonatomic) NSString *goods_image;
@property(strong,nonatomic) NSString *goods_name;
@property(strong,nonatomic) NSString *goods_time;
@property(strong,nonatomic) NSString *goods_price;

@property (weak, nonatomic) IBOutlet AddImageView *image1;
@property (weak, nonatomic) IBOutlet AddImageView *image2;
@property (weak, nonatomic) IBOutlet AddImageView *image3;
@end
