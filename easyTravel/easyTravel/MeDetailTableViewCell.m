//
//  MeDetailTableViewCell.m
//  easyTravel
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "MeDetailTableViewCell.h"
#import "CommonUtil.h"

@implementation MeDetailTableViewCell

@synthesize title;
@synthesize content;
@synthesize manCheckBox;
@synthesize manLabel;
@synthesize womanCheckBox;
@synthesize womanLabel;
@synthesize delegate;
@synthesize cellDraw;

- (void)awakeFromNib {
    // Initialization code
    title.textColor = [CommonUtil getColor:@"ababab"];
    content.textColor = [CommonUtil getColor:@"666666"];
    
    [self hideCheckBox];
    
    manCheckBox.selected = YES;
    womanCheckBox.selected = NO;
    [manCheckBox setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [manCheckBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [womanCheckBox setImage:[UIImage imageNamed:@"unChecked.png"] forState:UIControlStateNormal];
    [womanCheckBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    cellDraw = [[CellDraw alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    cellDraw.userInteractionEnabled=NO;
    cellDraw.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:cellDraw];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    cellDraw.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)checkBox1:(id)sender {
    manCheckBox.selected=!manCheckBox.selected;
    if(manCheckBox.selected){
        womanCheckBox.selected = NO;
    }
    if(manCheckBox.selected){
        content.text = @"男";
    }else{
        content.text = @"女";
    }
    
    if([delegate respondsToSelector:@selector(updateSex:)]){
        [delegate updateSex:[self getSexString]];
    }
    
}

- (IBAction)checkBox2:(id)sender {
    womanCheckBox.selected=!womanCheckBox.selected;
    if(womanCheckBox.selected){
        manCheckBox.selected = NO;
    }
    if(manCheckBox.selected){
        content.text = @"男";
    }else{
        content.text = @"女";
    }
    if([delegate respondsToSelector:@selector(updateSex:)]){
        [delegate updateSex:[self getSexString]];
    }
}

-(void)displayCheckBox{
    NSLog(@"%@",content.text);
    if([content.text isEqualToString:@"男"]){
        manCheckBox.selected=YES;
        womanCheckBox.selected=NO;
    }
    if([content.text isEqualToString:@"女"]){
        manCheckBox.selected=NO;
        womanCheckBox.selected=YES;
    }
    
    manCheckBox.hidden = NO;
    manLabel.hidden = NO;
    womanCheckBox.hidden = NO;
    womanLabel.hidden = NO;
    content.hidden = YES;
}

-(void)hideCheckBox{
    manCheckBox.hidden = YES;
    manLabel.hidden = YES;
    womanCheckBox.hidden = YES;
    womanLabel.hidden = YES;
    content.hidden = NO;
    
    if(manCheckBox.selected){
        content.text = @"男";
    }else{
        content.text = @"女";
    }
    
}

-(NSString*)getSexString{
    if([content.text isEqualToString:@"男"]){
        return @"1";
    }
    if([content.text isEqualToString:@"女"]){
        return @"2";
    }
    return @"3";
}



-(void)updateData:(NSMutableDictionary*)info:(int)row{
    
    if(row==2){
        if([[info valueForKeyPath:[NSString stringWithFormat:@"%d",row]] intValue]==1){
            self.content.text = @"男";
            manCheckBox.selected = YES;
            womanCheckBox.selected = NO;
        }else if([[info valueForKeyPath:[NSString stringWithFormat:@"%d",row]] intValue]==2){
            self.content.text = @"女";
            manCheckBox.selected = NO;
            womanCheckBox.selected = YES;
        }
    }else if(row==8){
        
    }else{
        self.content.text = [info valueForKeyPath:[NSString stringWithFormat:@"%d",row]];
    }


}
@end
