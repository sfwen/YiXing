//
//  BasicNavigationController.m
//  easyTravel
//
//  Created by Land on 2019/2/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController () <UINavigationControllerDelegate>

@end

@implementation BasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

@end
