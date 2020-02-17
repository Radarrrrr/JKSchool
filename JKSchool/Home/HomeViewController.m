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
@property (nonatomic, strong) UIImageView *faceView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UIButton *cateBtn;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"首页";
    
    //创建背景 高125
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, AT(125))];
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
    UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 10)];
    hview.backgroundColor = [UIColor clearColor];
    [_contentTable setSection:0 headerView:hview footerView:nil];
    
    //[_contentTable appendData:@"这时第1段" useCell:@"ScrollCell" toSection:0];
    
    
    //添加用户头像和班级
    [self addUserInfos];
    
    //创建用户条
    //[self addUserBanner];
    
    
    //启动数据读取
    [self engineStartLoading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



#pragma mark - 数据读取连续引擎
- (void)engineStartLoading
{
    //读取用户banner数据
    [self loadingUserInfos];  
    
    //读取轮播图楼层
    [self loadingCircleScroll:^{

        //读取小喇叭楼层
        [self loadingHorn:^{
            
            //设定icon入口区楼层
            [self loadingIcons:^{
                
                //根据身份类型分支展示
                HHUser *user = [UserInfo sharedInfo].curUser;
                if([user.type isEqualToString:@"PARENTS"])
                {
                    //**家长身份**
                    
                    //设定请假管理楼层
                    [self loadingLeaveManage:^{
                        
                        //读取通知楼层
                        
                    }];
                    
                    
                    
                }
                else if([user.type isEqualToString:@"TEACHER"])
                {
                    //**班主任身份**
                    
                    //晨午检
                    
                    //学生审批
                     
                }
                
                
                
                //处理下个楼层业务
                //...
                
            }];
            
        }];

    }];
}





#pragma mark - 浮层工具条
- (void)callCategroyLayer
{
    //起浮层
    
}




#pragma mark - 用户信息楼层
- (void)addUserInfos
{
    //添加用户头像ITEM
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    faceBtn.frame = CGRectMake(0, 0, 120, 44);
    faceBtn.backgroundColor = [UIColor clearColor];
    [faceBtn addTarget:self action:@selector(callCategroyLayer) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *faceItem = [[UIBarButtonItem alloc] initWithCustomView:faceBtn];
    self.navigationItem.leftBarButtonItem = faceItem;
    
    //添加头像
    self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 36, 36)];
    _faceView.userInteractionEnabled = NO;
    [RDFunction addRadiusToView:_faceView radius:18];
    [RDFunction addBorderToView:_faceView color:RGBS(220) lineWidth:1];
    [faceBtn addSubview:_faceView];
    
    //添加姓名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 12, 80, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.userInteractionEnabled = NO;
    _nameLabel.textColor = COLOR_TEXT_A;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = FONT(14);
    [faceBtn addSubview:_nameLabel];

    
    //添加班级ITEM
    self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _classLabel.backgroundColor = [UIColor blackColor];
    _classLabel.alpha = 0.20;
    _classLabel.userInteractionEnabled = NO;
    _classLabel.textColor = [UIColor whiteColor];
    _classLabel.textAlignment = NSTextAlignmentCenter;
    _classLabel.font = FONT(14);
    [RDFunction addRadiusToView:_classLabel radius:10];
    
    UIBarButtonItem *classItem = [[UIBarButtonItem alloc] initWithCustomView:_classLabel];
    self.navigationItem.rightBarButtonItem = classItem;
    
}
//- (void)addUserBanner
//{
//    //容器条
//    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 50)];
//    userView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:userView];
//    [self.view bringSubviewToFront:userView];
//
//    //添加头像
//    self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
//    [RDFunction addRadiusToView:_faceView radius:15];
//    [userView addSubview:_faceView];
//
//    //添加姓名
//    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceView.frame)+10, 15, 200, 20)];
//    _nameLabel.backgroundColor = [UIColor clearColor];
//    _nameLabel.userInteractionEnabled = NO;
//    _nameLabel.textColor = [UIColor whiteColor];
//    _nameLabel.textAlignment = NSTextAlignmentLeft;
//    _nameLabel.font = FONT(14);
//    [userView addSubview:_nameLabel];
//
//    //滑层按钮
//    self.cateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _cateBtn.frame = CGRectMake(VIEW_WIDTH-20-20, 15, 20, 20);
//    [_cateBtn setBackgroundImage:IMAGE(@"icon_category") forState:UIControlStateNormal];
//    [_cateBtn addTarget:self action:@selector(callCategroyLayer) forControlEvents:UIControlEventTouchUpInside];
//    [userView addSubview:_cateBtn];
//
//    //班级
//    self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cateBtn.frame)-100-10, 15, 100, 20)];
//    _classLabel.backgroundColor = [UIColor blackColor];
//    _classLabel.alpha = 0.5;
//    _classLabel.userInteractionEnabled = NO;
//    _classLabel.textColor = [UIColor whiteColor];
//    _classLabel.textAlignment = NSTextAlignmentCenter;
//    _classLabel.font = FONT(14);
//    [RDFunction addRadiusToView:_classLabel radius:10];
//    [userView addSubview:_classLabel];
//}

- (void)loadingUserInfos
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
    
    [self fillUserBannerForData:testData];
}

- (void)fillUserBannerForData:(NSDictionary *)userData
{
    if(!DICTIONARYVALID(userData)) return;
    
    //填充头像
    NSString *sex = [RDFunction valueOfData:userData byPath:@"data.sex"];
    if([sex isEqualToString:@"0"])
    {
        _faceView.image = IMAGE(@"default_face_boy");
    }
    else
    {
        _faceView.image = IMAGE(@"default_face_girl");
    }
    
    //填充姓名
    _nameLabel.text = [RDFunction valueOfData:userData byPath:@"data.username"];
 
    //填充班级
    _classLabel.text = [RDFunction valueOfData:userData byPath:@"data.address"];
    //修改长度
    float lw = [self getWidthForString:_classLabel.text font:_classLabel.font height:20];
    CGRect nrect = _classLabel.frame;
    nrect.size.width = lw+20;
    nrect.origin.x = CGRectGetMinX(_cateBtn.frame)-(lw+20)-10;
    _classLabel.frame = nrect;
}

- (float)getWidthForString:(NSString *)string font:(UIFont *)font height:(float)height
{
    if(!string || [string compare:@""] == NSOrderedSame) return 0.0;
    
    //段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *useString = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    
    CGSize size =  [useString boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    //NSLog(@" size =  %@", NSStringFromCGSize(size));
    
    //计算出来的数据是小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1；
    CGFloat width = ceil(size.width) + 1;
    
    return width;
}




#pragma mark - 轮播图楼层
- (void)loadingCircleScroll:(void(^)(void))completion
{
    [RDNetService requestGetWithURL:RequestUrlMake(ACTION_ROTATES, nil) progress:^(double progress) {
        
    } success:^(id response) {
        
        //处理轮播图数据
        [self handleCircleData:response completion:^{
            if(completion)
            {
                completion();
            }
        }];
        
    } failure:^(NSDictionary *errdic) {
        
        //处理数据读取失败提示
        if(completion)
        {
            completion();
        }
    }];
}



- (void)handleCircleData:(NSDictionary*)data completion:(void(^)(void))completion
{
    if(!DICTIONARYVALID(data)) return;
    if(!NICEDATA(data)) return;
    
    NSArray *arrays = [data objectForKey:@"data"];
    //[_contentTable appendData:arrays useCell:@"ScrollCell" toSection:0];
    
    //填充数据
    [_contentTable insertData:arrays useCell:@"ScrollCell" toIndexPath:RDIndexPath(0, 0)];
    
    //刷新页面
    [self->_contentTable refreshTableWithAnimation:UITableViewRowAnimationFade completion:^{
        
        if(completion)
        {
            completion();
        }
    } ];

}







#pragma mark - 小喇叭楼层
- (void)loadingHorn:(void(^)(void))completion
{
    [RDNetService requestGetWithURL:RequestUrlMake(ACTION_MESSAGES, nil) progress:^(double progress) {
        
    } success:^(id response) {
        
        //处理轮播图数据
        [self handleHornData:response completion:^{
            if(completion)
            {
                completion();
            }
        }]; 
        
    } failure:^(NSDictionary *errdic) {
        
        //处理数据读取失败提示
        
        
        //TO DO: 这里是测试数据，需要调试消息列表接口
        //----------------测试的数据
        NSDictionary *data = @{@"status_code":@"200",
                               @"data":@[
                                         @{@"link_word":@"张无忌的入会申请", @"link_url":@"http://www.baidu.com"},
                                         @{@"link_word":@"王重阳九阳神功", @"link_url":@"http://www.163.com"},
                                         @{@"link_word":@"张慧仪入班申请", @"link_url":@"http://www.cdhhrs.com"}
                                        ]
                               };
        [self handleHornData:data completion:^{
            if(completion)
            {
                completion();
            }
        }]; 
        
        return;
        //----------------
        
        
        
        
        if(completion)
        {
            completion();
        }
    }];
}

- (void)handleHornData:(NSDictionary*)data completion:(void(^)(void))completion
{
    if(!DICTIONARYVALID(data)) return;
    if(!NICEDATA(data)) return;
    
    //拿到小喇叭数据数组
    NSArray *arrays = [data objectForKey:@"data"];
    
    //做小喇叭楼层
    [_contentTable insertData:arrays useCell:@"HornCell" toIndexPath:RDIndexPath(0, 1)];
    
    //刷新页面
    [self->_contentTable refreshTableWithAnimation:UITableViewRowAnimationFade completion:^{
        
        if(completion)
        {
            completion();
        }
    } ];
}



#pragma mark - icon区楼层
- (void)loadingIcons:(void(^)(void))completion
{
    //根据身份权限不同，读取不同icons
    //icons: [{"icon_img":"xxx", "icon_name":"xxx", "link_url":"xxxx"},...]   
    NSArray *data = nil;
    
    HHUser *user = [UserInfo sharedInfo].curUser;
    if(!user)
    {
        //没登录，只能看学校简介
        data = @[@{@"icon_img":@"icon_school_desc", @"icon_name":@"学校简介", @"link_url":@"xxxx"}];
    }
    else
    {
        if([user.type isEqualToString:@"PARENTS"])
        {
            //家长身份
            data = @[@{@"icon_img":@"icon_student_doc", @"icon_name":@"学生档案", @"link_url":@"studentdoc://"},
                     @{@"icon_img":@"icon_leave_manage", @"icon_name":@"请假管理", @"link_url":@"leavemanage://"},
                     @{@"icon_img":@"icon_health_data", @"icon_name":@"健康数据", @"link_url":@"healthdata://"},
                     @{@"icon_img":@"icon_school_desc", @"icon_name":@"学校简介", @"link_url":@"schooldesc://"}
                     ];
        }
        else if([user.type isEqualToString:@"TEACHER"])
        {
            //班主任身份
            data = @[@{@"icon_img":@"icon_teacher_manage", @"icon_name":@"老师管理", @"link_url":@"teachermanage://"},
                     @{@"icon_img":@"icon_student_manage", @"icon_name":@"学生管理", @"link_url":@"studentmanage://"},
                     @{@"icon_img":@"icon_alarm_msg", @"icon_name":@"预警信息", @"link_url":@"alarmmsg://"},
                     @{@"icon_img":@"icon_checking_mn", @"icon_name":@"晨午检", @"link_url":@"checking://"},
                     @{@"icon_img":@"icon_leave_manage", @"icon_name":@"请假管理", @"link_url":@"leavemanage://"},
                     @{@"icon_img":@"icon_health_data", @"icon_name":@"健康数据", @"link_url":@"healthdata://"},
                     @{@"icon_img":@"icon_schedule", @"icon_name":@"课程表", @"link_url":@"schedule://"},
                     @{@"icon_img":@"icon_activity_notice", @"icon_name":@"活动通知", @"link_url":@"activitynotice://"},
                     @{@"icon_img":@"icon_school_desc", @"icon_name":@"学校简介", @"link_url":@"schooldesc://"}
                     ];
        }
                
        //TO DO: ...其他身份以后再添加
    }
    
    //处理数据源
    [self handleIconsData:data completion:^{
        if(completion)
        {
            completion();
        }
    }];
}

- (void)handleIconsData:(NSArray*)data completion:(void(^)(void))completion
{
    //data: [{"icon_img":"xxx", "icon_name":"xxx", "link_url":"xxxx"},...]
    if(!ARRAYVALID(data)) return;
    
    //做icons区楼层
    [_contentTable insertData:data useCell:@"IconsCell" toIndexPath:RDIndexPath(0, 2)];
    
    //刷新页面
    [self->_contentTable refreshTableWithAnimation:UITableViewRowAnimationFade completion:^{
        
        if(completion)
        {
            completion();
        }
    } ];
}



#pragma mark - 请假管理楼层
- (void)loadingLeaveManage:(void(^)(void))completion
{
    //请假管理
    //做一个空字典传入，因为RDTableview需要data不为nil
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    //处理数据源
    [self handleLeaveManageData:data completion:^{
        if(completion)
        {
            completion();
        }
    }];
}

- (void)handleLeaveManageData:(NSDictionary*)data completion:(void(^)(void))completion
{
    //data暂时先不需要可按nil处理
    //做icons区楼层
    [_contentTable insertData:data useCell:@"LeaveManageCell" toIndexPath:RDIndexPath(0, 3)];
    
    //刷新页面
    [self->_contentTable refreshTableWithAnimation:UITableViewRowAnimationFade completion:^{
        
        if(completion)
        {
            completion();
        }
    } ];
}


@end
