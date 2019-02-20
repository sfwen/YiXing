//
//  Msg.h
//  easyTravel
//
//  Created by apple on 15/8/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Msg : NSObject


@property(strong,nonatomic) NSString *create_time;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *content;
@property(assign,nonatomic) int is_read;
@property(assign,nonatomic) int id;


@end
