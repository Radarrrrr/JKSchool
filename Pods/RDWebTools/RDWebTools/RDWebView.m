//
//  RDWebView.m
//  RDWebToolsDemo
//
//  Created by Radar on 2018/3/6.
//  Copyright © 2018年 Radar. All rights reserved.
//

#import "RDWebView.h"

@interface RDWebView () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, copy)   NSString *url;     //要加载的url
@property (nonatomic, strong) UIView *progressLine;

@property (nonatomic) void (^titleHandler)(NSString *title);
@property (nonatomic) void (^urlHandler)(NSString *url);

@end


@implementation RDWebView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.showGoback = NO;
        
        self.urlsArray = [[NSMutableArray alloc] init];
        
        //创建webview
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];  
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) configuration:configuration];  
        _webView.navigationDelegate = self;
        [self addSubview:_webView];
        
        //添加进度条
        self.progressLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 2.5)];
        _progressLine.backgroundColor = [UIColor colorWithRed:67.0/255.0 green:142.0/255.0 blue:255.0/255.0 alpha:1.0];
        _progressLine.userInteractionEnabled = NO;
        _progressLine.alpha = 0.0;
        [self addSubview:_progressLine];
        
        //添加KVO监听
        [self addKVOtoWebView];
         
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if(_webView)
    {
        //修正web的frame
        _webView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        //修正返回按钮的frame
        UIButton *backBtn = [self viewWithTag:10086];
        if(backBtn)
        {
            backBtn.frame = CGRectMake(0, frame.size.height-40, 40, 40);
        }
    }
}

- (void)dealloc
{    
    if(_webView)
    {
        [self removeKVOtoWebView];
    }
}



- (void)drawRect:(CGRect)rect {

    //添加返回上级按钮
    if(_showGoback)
    {
        //放在左下角
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        backBtn.frame = CGRectMake(0, self.frame.size.height-40, 40, 40);
        backBtn.tag = 10086;
        [backBtn setImage:[UIImage imageNamed:@"icon_rdweb_goback.png"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
    }
    
    //刷新网页
    if(_url && ![_url isEqualToString:@""])
    {
        //如果不带http或https开头，则自动补充一个
        if(![_url hasPrefix:@"http://"] && ![_url hasPrefix:@"https://"])
        {
            self.url = [NSString stringWithFormat:@"http://%@", _url];
        }
        
        [_urlsArray addObject:_url];
        
        NSURL *request = [NSURL URLWithString:_url];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:request cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:[[NSDate date] timeIntervalSinceReferenceDate]];
        [_webView loadRequest:urlRequest];
    }
    
}



#pragma mark - 外部方法
- (void)loadURL:(NSString *)url
{
    self.url = url;
    [self setNeedsDisplay];
}

- (void)observeWebView:(void(^)(NSString *title))currentTitle currentUrl:(void(^)(NSString *url))currentUrl
{
    self.titleHandler = currentTitle;
    self.urlHandler = currentUrl;
}



#pragma mark - 配套方法
- (void)changeProgressState:(double)progress
{
    float toalpha = 1.0;
    if(progress == 0.0 || progress == 1.0)
    {
        toalpha = 0.0;
    }
    
    float lw = self.frame.size.width*progress;
    
    //移动动画
    [UIView animateWithDuration:0.15 animations:^{
        
        CGRect lframe = _progressLine.frame;
        lframe.size.width = lw;
        _progressLine.frame = lframe;
        
    }];
    
    //显示／隐藏控制
    if(progress < 1.0)
    {
        _progressLine.alpha = toalpha;
    }
    else
    {
        [UIView animateWithDuration:0.25 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _progressLine.alpha = toalpha;
            
        } completion:^(BOOL finished) {
            
            CGRect lframe = _progressLine.frame;
            lframe.size.width = 0;
            _progressLine.frame = lframe;
            
        }];
    }
}

- (void)goBackAction:(id)sender
{
    if(_webView.canGoBack)
    {
        [_webView goBack];
    }
}


#pragma mark - KVO 监听加载进度
- (void)addKVOtoWebView
{
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeKVOtoWebView
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) 
    {
        NSLog(@"加载进度：%f", self.webView.estimatedProgress);
        [self changeProgressState:self.webView.estimatedProgress];
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}







#pragma mark - WKNavigationDelegate
//追踪加载过程（页面开始加载、加载完成、加载失败）、决定是否执行跳转。
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    // 页面开始加载时调用 
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    // 当内容开始返回时调用 
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    // 页面加载完成之后调用 
    if(_titleHandler)
    {
        _titleHandler(webView.title);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    // 页面加载失败时调用 
    
}


//页面跳转的代理有三种，分别为（收到跳转与决定是否跳转两种）
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    // 接收到服务器跳转请求之后调用
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    // 在收到响应后，决定是否跳转  
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 在发送请求之前，决定是否跳转 
    NSString *url = navigationAction.request.URL.absoluteString;
    NSLog(@"%@", url);

    [_urlsArray addObject:url];
    
    if(_urlHandler)
    {
        _urlHandler(url);
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


//SSL认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler
{
    NSString *authenticationMethod = [[challenge protectionSpace] authenticationMethod];
    
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *credential = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        
    }
}






@end
