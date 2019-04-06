//
//  LoginViewController.m
//  JKSchool
//
//  Created by radar on 2019/4/6.
//  Copyright © 2019 radar. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *telField;
@property (nonatomic, strong) UITextField *codeField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"欢迎登录";
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyBoard)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGesture];
    
    //back view
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, AT(375), AT(192))];
    backView.image = IMAGE(@"login_back");
    [self.view addSubview:backView];
    
    //add name
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 230, SCR_WIDTH, 28);
    label.text = @"健康校园管理平台";
    label.font = FONT_B(20);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    //add phone
    self.telField = [[UITextField alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(label.frame)+35, SCR_WIDTH-100, 40)];
    _telField.placeholder = @"请输入手机号";
    _telField.textAlignment = NSTextAlignmentLeft;
    _telField.textColor = [UIColor blackColor];
    _telField.font = FONT(16);
    _telField.keyboardType = UIKeyboardTypePhonePad;
    [RDFunction addLineToViewBottom:_telField useColor:COLOR(@"#EDEDED")];
    [self.view addSubview:_telField];
    
    //add code
    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_telField.frame)+15, SCR_WIDTH-100, 40)];
    _codeField.placeholder = @"请输入密码";
    _codeField.textAlignment = NSTextAlignmentLeft;
    _codeField.textColor = [UIColor blackColor];
    _codeField.font = FONT(16);
    [RDFunction addLineToViewBottom:_codeField useColor:COLOR(@"#EDEDED")];
    [self.view addSubview:_codeField];
    
    //add codebtn
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    codeBtn.frame = CGRectMake(SCR_WIDTH-20-80, CGRectGetMinY(_codeField.frame), 80, 40);
    codeBtn.titleLabel.font = FONT(14);
    [codeBtn setTitleColor:COLOR(@"#00B9AA") forState:UIControlStateNormal];
    [codeBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    
    //add images
    UIImageView *telView = [[UIImageView alloc] init];
    telView.frame = CGRectMake(20, CGRectGetMinY(_telField.frame)+8, 20, 20);
    telView.image = [UIImage imageNamed:@"icon_tel.png"];
    [self.view addSubview:telView];
    
    UIImageView *verifyView = [[UIImageView alloc] init];
    verifyView.frame = CGRectMake(20, CGRectGetMinY(_codeField.frame)+8, 20, 20);
    verifyView.image = [UIImage imageNamed:@"icon_verify.png"];
    [self.view addSubview:verifyView];
    
    
    //add loginbtn
    UIButton *loginBtn = [UIButton buttonWithColor:COLOR(@"#00DDCB") selColor:COLOR(@"#00B9AA")];
    loginBtn.frame = CGRectMake(20, CGRectGetMaxY(_codeField.frame)+15, AT(335), 44);
    loginBtn.titleLabel.font = FONT(16);
    [loginBtn setTitleColor:COLOR(@"##FFFFFF") forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [RDFunction addRadiusToView:loginBtn radius:22];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)registerAction
{
    //TO DO: 去注册
    
}

- (void)loginAction
{
    //TO DO: 登录
    
}

- (void)closeKeyBoard
{
    if([_telField isFirstResponder])
    {
        [_telField resignFirstResponder];
    }
    else if([_codeField isFirstResponder])
    {
        [_codeField resignFirstResponder];
    }
}


@end
