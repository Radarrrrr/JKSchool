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
    self.navigationItem.title = @"健康校园";
    
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
    UIView *hview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 50)];
    hview.backgroundColor = [UIColor clearColor];
    [_contentTable setSection:0 headerView:hview footerView:nil];
    
    //[_contentTable appendData:@"这时第1段" useCell:@"ScrollCell" toSection:0];



    
    //创建用户条
    [self addUserBanner];
    
    
    //启动数据读取
    [self engineStartLoading];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)engineStartLoading
{
    //读取用户banner数据
    [self loadingUserBanner];
    
    //读取轮播图楼层
    [self loadingCircleScroll:^{
        
        //处理下个楼层业务
        
        
        [self->_contentTable refreshTable:^{
            
        }];
    }];
}





#pragma mark - 用户信息楼层
- (void)addUserBanner
{    
    //容器条
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 50)];
    userView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userView];
    [self.view bringSubviewToFront:userView];
    
    //添加头像
    self.faceView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
    [RDFunction addRadiusToView:_faceView radius:15];
    [userView addSubview:_faceView];
    
    //添加姓名
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_faceView.frame)+10, 15, 200, 20)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.userInteractionEnabled = NO;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = FONT(14);
    [userView addSubview:_nameLabel];
    
    //滑层按钮
    self.cateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cateBtn.frame = CGRectMake(VIEW_WIDTH-20-20, 15, 20, 20);
    [_cateBtn setBackgroundImage:IMAGE(@"icon_category") forState:UIControlStateNormal];
    [_cateBtn addTarget:self action:@selector(callCategroyLayer) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:_cateBtn];
    
    //班级
    self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cateBtn.frame)-100-10, 15, 100, 20)];
    _classLabel.backgroundColor = [UIColor blackColor];
    _classLabel.alpha = 0.5;
    _classLabel.userInteractionEnabled = NO;
    _classLabel.textColor = [UIColor whiteColor];
    _classLabel.textAlignment = NSTextAlignmentCenter;
    _classLabel.font = FONT(14);
    [RDFunction addRadiusToView:_classLabel radius:10];
    [userView addSubview:_classLabel];
}

- (void)loadingUserBanner
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
        [self handleCircleData:response];
        
        if(completion)
        {
            completion();
        }
        
    } failure:^(NSDictionary *errdic) {
        
        //处理数据读取失败提示
        if(completion)
        {
            completion();
        }
    }];
}

- (void)handleCircleData:(NSDictionary*)data
{
    if(!DICTIONARYVALID(data)) return;
    if(!NICEDATA(data)) return;
    
    NSArray *arrays = [data objectForKey:@"data"];
    [_contentTable appendData:arrays useCell:@"ScrollCell" toSection:0];
}




#pragma mark - 浮层工具条
- (void)callCategroyLayer
{
    //起浮层
    
}



@end
