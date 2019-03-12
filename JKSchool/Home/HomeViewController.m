//
//  HomeViewController.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <RDTableViewDelegate>

@property (nonatomic, strong) RDTableView *contentTable;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"健康校园";
    
//    [RDNetService requestGetWithURL:RequestUrlMake(ACTION_ROTATES, nil) progress:^(double progress) {
//        
//    } success:^(id response) {
//        
//        int i=0;
//    } failure:^(NSDictionary *errdic) {
//        
//    }];
    
    
    //创建背景 高125
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 125)];
    backView.image = IMAGE(@"home_back_img");
    [self.view addSubview:backView];
    
    
    //创建列表
    self.contentTable = [[RDTableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    _contentTable.delegate = self;
    _contentTable.backgroundColor = [UIColor clearColor];
    _contentTable.tableView.backgroundColor = [UIColor clearColor];             
    _contentTable.tableView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _contentTable.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_contentTable];
    

    //设定header和footer的view
    UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 50)];
    hview.backgroundColor = [UIColor clearColor];
    [_contentTable setSection:0 headerView:hview footerView:nil];
    
    [_contentTable appendData:@"这时第1段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第2段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第3段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第4段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第5段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第6段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第7段" useCell:@"ScrollCell" toSection:0];
    [_contentTable appendData:@"这时第8段" useCell:@"ScrollCell" toSection:0];
    
    //创建用户条
    [self loadUserBanner];
    
}

- (void)loadUserBanner
{
    /*
    {
        "status_code": "string",
        "message": "string",
        "data": {
            "id": 0,
            "username": "string",
            "realname": "string",
            "email": "string",
            "mobile": "string",
            "avatar": "string",
            "address": "string",
            "sex": 0,
            "roles": [
                      "string"
                      ]
        }
    }
    */
    
    //TO DO: 异步读取数据
    NSDictionary *testData = @{@"status_code":@"200",
                               @"data":@{
                                       @"id":@"0",
                                       @"username":@"张慧仪会",
                                       @"sex": @"0",
                                       @"address":@"小托班一班"
                                       }
                               };
    
    [self drawUserBannerForData:testData];
}

- (void)drawUserBannerForData:(NSDictionary *)userData
{
    if(!DICTIONARYVALID(userData)) return;
    
    //容器条
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 50)];
    userView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userView];
    [self.view bringSubviewToFront:userView];
    
    //添加头像
    UIImageView *faceV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    [RDFunction addRadiusToView:faceV radius:15];
    [userView addSubview:faceV];
    
    NSString *sex = [RDFunction valueOfData:userData byPath:@"data.sex"];
    if([sex isEqualToString:@"0"])
    {
        faceV.image = IMAGE(@"default_face_boy");
    }
    else
    {
        faceV.image = IMAGE(@"default_face_girl");
    }
    
    //添加姓名
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(faceV.frame)+10, 15, 100, 20)];
    nameL.backgroundColor = [UIColor clearColor];
    nameL.userInteractionEnabled = NO;
    nameL.textColor = [UIColor whiteColor];
    nameL.textAlignment = NSTextAlignmentLeft;
    nameL.font = FONT(14);
    nameL.text = [RDFunction valueOfData:userData byPath:@"data.username"];
    [userView addSubview:nameL];
    
    //班级
    UILabel *classL = [[UILabel alloc] initWithFrame:CGRectMake(122, 15, 100, 20)];
    classL.backgroundColor = [UIColor blackColor];
    classL.alpha = 0.5;
    classL.userInteractionEnabled = NO;
    classL.textColor = [UIColor whiteColor];
    classL.textAlignment = NSTextAlignmentCenter;
    classL.font = FONT(14);
    classL.text = [RDFunction valueOfData:userData byPath:@"data.address"];
    [RDFunction addRadiusToView:classL radius:10];
    [userView addSubview:classL];
    
    //滑层按钮
    UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    cateBtn.frame = CGRectMake(VIEW_WIDTH-20-20, 15, 20, 20);
    [cateBtn setBackgroundImage:IMAGE(@"icon_category") forState:UIControlStateNormal];
    [cateBtn addTarget:self action:@selector(callCategroyLayer) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:cateBtn];

}

- (void)callCategroyLayer
{
    //起浮层
    
}


@end
