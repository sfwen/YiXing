//
//  LevelUpViewController.h
//  easyTravel
//
//  Created by apple on 15/8/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SequenceTextView.h"

@interface LevelUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet SequenceTextView *leftGroupText1;
@property (weak, nonatomic) IBOutlet SequenceTextView *leftGroupText2;
@property (weak, nonatomic) IBOutlet SequenceTextView *leftGroupText3;
@property (weak, nonatomic) IBOutlet SequenceTextView *leftGroupText4;
@property (weak, nonatomic) IBOutlet SequenceTextView *leftGroupText5;
@property (weak, nonatomic) IBOutlet SequenceTextView *leftGroupText6;

@property (weak, nonatomic) IBOutlet SequenceTextView *rightGroupText1;
@property (weak, nonatomic) IBOutlet SequenceTextView *rightGroupText2;
@property (weak, nonatomic) IBOutlet SequenceTextView *rightGroupText3;
@property (weak, nonatomic) IBOutlet SequenceTextView *rightGroupText4;
@property (weak, nonatomic) IBOutlet SequenceTextView *rightGroupText5;
@property (weak, nonatomic) IBOutlet SequenceTextView *rightGroupText6;

@property (weak, nonatomic) IBOutlet UIView *vLine;
@property (weak, nonatomic) IBOutlet UIView *hTopLine;
@property (weak, nonatomic) IBOutlet UIView *hBottomLine;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
- (IBAction)level1Up:(id)sender;
- (IBAction)level2Up:(id)sender;
@end
