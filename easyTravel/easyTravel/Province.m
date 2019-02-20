//
//  Province.m
//  easyTravel
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "Province.h"

@implementation Province


-(id)init{
    self = [super init];
    if(self){
        _cityArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addCity:(City*)city{
    [_cityArray addObject:city];
}

@end
