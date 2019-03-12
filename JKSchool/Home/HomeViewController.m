//
//  HomeViewController.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"健康校园";
    
    [RDNetService requestGetWithURL:RequestUrlMake(ACTION_ROTATES, nil) progress:^(double progress) {
        
    } success:^(id response) {
        
        int i=0;
    } failure:^(NSDictionary *errdic) {
        
    }];
    
}



@end
