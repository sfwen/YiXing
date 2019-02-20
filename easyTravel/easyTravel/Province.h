//
//  Province.h
//  easyTravel
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface Province : NSObject


@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* pID;
@property(nonatomic,strong)NSMutableArray *cityArray;

-(void)addCity:(City*)city;

@end
