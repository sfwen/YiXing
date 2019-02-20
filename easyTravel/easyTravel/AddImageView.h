//
//  AddImageView.h
//  easyTravel
//
//  Created by apple on 15/7/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectPhotosDelegate <NSObject>
-(void)addImage:(int)tag;
-(void)deleteImage:(int)tag;
@end

@interface AddImageView : UIView<UIGestureRecognizerDelegate>

@property (assign, nonatomic) id<SelectPhotosDelegate> delegate;

@property(strong,nonatomic) UIImageView *imageView;
@property(strong,nonatomic) UIButton *closeBtn;

@end
