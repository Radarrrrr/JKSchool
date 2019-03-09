//
//  RDWebViewController.h
//  RDWebToolsDemo
//
//  Created by Radar on 2018/3/6.
//  Copyright © 2018年 Radar. All rights reserved.
//
//本类基于WKWebView实现网页加载
//v1.0.0 版本仅支持push方式使用

//注意：
/*
必须要在 info.plist 里边添加如下ATS设定，以便可以支持http请求：
<App Transport Security Settings> -> <Allow Arbitrary Loads> 设定为 YES
*/


//使用方式如下：
/*
 RDWebViewController *webVC = [[RDWebViewController alloc] init];
 webVC.url = @"http://www.baidu.com";
 [self.navigationController pushViewController:webVC animated:YES];
 */



#import <UIKit/UIKit.h>
#import "RDWebView.h"

@interface RDWebViewController : UIViewController

@property (nonatomic, copy) NSString *url;        //要加载的url
@property (nonatomic, copy) NSString *navTitle;   //要显示在导航条上的title，如果存在且不为空，则固定使用此title / 如果设定为nil，则使用url内自带的title / 如果设定为@""，则完全不显示title

@property (nonatomic)       BOOL showNavBar;        //default is YES，是否显示顶部导航条
@property (nonatomic)       BOOL showGoback;        //default is NO， 是否显示返回上一层的按钮 

//TO DO: 是否还需要这个goback？应该用导航条的关闭按钮来表示，类似微信

//重新加载URL，用于第一次已经加载过以后，还需要再次加载其他url的情况
- (void)reloadURL:(NSString *)url; 


@end
