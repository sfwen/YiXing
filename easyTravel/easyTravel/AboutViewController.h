//
//  AboutViewController.h
//  easyTravel
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *phoneText;
- (IBAction)callPhone:(id)sender;

@property(copy,nonatomic)NSString *imageUrl;
@property(copy,nonatomic)NSString *webViewUrl;

@end
