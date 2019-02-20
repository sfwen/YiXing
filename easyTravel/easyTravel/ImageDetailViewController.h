//
//  ImageDetailViewController.h
//  easyTravel
//
//  Created by apple on 15/7/28.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController


@property(strong,nonatomic)NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
