//
//  RDWebView.h
//  RDWebToolsDemo
//
//  Created by Radar on 2018/3/6.
//  Copyright © 2018年 Radar. All rights reserved.
//
//本类基于WKWebView实现网页加载

//注意：
/*
必须要在 info.plist 里边添加如下ATS设定，以便可以支持http请求：
<App Transport Security Settings> -> <Allow Arbitrary Loads> 设定为 YES
*/


//使用方式如下：
/*
RDWebView *webView = [[RDWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
[self.view addSubview:webView];
[webView loadURL:@"http://www.baidu.com"];
*/


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface RDWebView : UIView

//供外部设定的属性
@property (nonatomic)         BOOL showGoback;   //default is NO， 在webview中显示返回上一层的按钮

//供外部调取使用的属性
@property (nonatomic, strong) WKWebView *webView;        //内部的WKWebView，外部可以在需要的时候添加KVO监听
@property (nonatomic, strong) NSMutableArray *urlsArray; //记录了一次url进来以后，从开始加载到重定向完成以后的所有跳转url


//加载URL，本类就这一个加载方法，随时可以使用这个方法加载url
- (void)loadURL:(NSString *)url; 

//- (void)changeFrame:(CGRect)frame;

//监听当前最新的title和url
- (void)observeWebView:(void(^)(NSString *title))currentTitle currentUrl:(void(^)(NSString *url))currentUrl; 


@end
