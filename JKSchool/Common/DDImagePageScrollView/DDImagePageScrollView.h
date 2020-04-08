//
//  DDImagePageScrollView.h
//  DangDangHD
//
//  Created by Radar on 12-11-16.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//  

//PS: 使用本模块，需要添加 QuartzCore.framework

//使用方法:
/*
//1. add DDImagePageScrollView
DDImagePageScrollView *imgPageScrollView = [[DDImagePageScrollView alloc] initWithFrame:CGRectMake((1024-675)/2, (748-245)/2, 675, 245)];
imgPageScrollView.backgroundColor = [UIColor clearColor]; //PS:如果设定bPageRoundRect=YES, 则backgroundColor必须为clearColor
imgPageScrollView.delegate = self;
imgPageScrollView.roundRectEnabled = YES;
imgPageScrollView.cacheEnabled = YES;
imgPageScrollView.tapEnabled = YES;
imgPageScrollView.zoomEnabled = YES;
imgPageScrollView.pageCtrlEnabled = YES;
imgPageScrollView.ingoreMemory = NO;
imgPageScrollView.autoPlayTimeInterval = 3;
[self.view addSubview:imgPageScrollView];
[imgPageScrollView release];

//2. refresh pageScrollView
NSArray *imageURLs = [NSArray arrayWithObjects:@"url1", @"url2",... nil];
[imgPageScrollView refreshPagesForImageURLs:imageURLs startIndex:3];
*/




#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DDURLImageView.h"
#import "DDTimer.h"


enum pageCtrolhorizontalAlignment{
      left =0,
      right=1,
      center=2
};

#define minZoomScale 1.0  //最小缩放比例
#define maxZoomScale 4.0  //最大缩放比例


@class DDImagePageScrollView;
@protocol DDImagePageScrollViewDelegate<NSObject>
@optional
//本类切换到某一个page的时候，返回当前切换到的page的index
- (void)ddImagePageScrollViewDidChangeToPageIndex:(DDImagePageScrollView*)pageScrollView pageIndex:(NSInteger)index; 

//本类读取完毕某一个page的图片的时候，返回此方法，注意：finishIndex是完成读取的那个page的index，而不是当前page的index
- (void)ddImagePageScrollViewDidFinishLoadingPage:(DDImagePageScrollView*)pageScrollView finishPageIndex:(NSInteger)index finishImage:(UIImage*)image;

//本类选择一个page的时候，返回此方法，同时返回选择的page的index，image，和imageURL 
//PS:返回的atPoint是点击点在DDURLImageView区域上的坐标，而不是图片，如果图片点击之前做了zoom，则坐标点和图片上的点无法对应，需要额外作坐标对应处理
- (void)ddImagePageScrollViewDidTapInPage:(DDImagePageScrollView*)pageScrollView pageIndex:(NSInteger)index atPoint:(CGPoint)atPoint pageImage:(UIImage*)image pageImageURL:(NSString*)imageURL;

@end



@interface DDImagePageScrollView : UIView <DDTimerDelegate, DDURLImageViewDelegate, UIScrollViewDelegate> {

	UIScrollView *_scrollView;
	NSArray *_imageURLs; //根据images的个数确定里面有多少个imageview, images是由图片的URL组成的数组
	NSMutableArray *_pages;

    UIActivityIndicatorView *_spinner;
    
	NSInteger _currentScrollIndex; //当前scroll上页面的index，如果是circle模式，需要转换成数据源的index，这两个间有偏差
    
    BOOL _roundRectEnabled; //PS:参数设定，必须在refreshPagesForImageURLs之前完成
	BOOL _zoomEnabled;
    BOOL _tapEnabled;
    BOOL _cacheEnabled;
    BOOL _pageCtrlEnabled;
    BOOL _circleEnabled;
    BOOL _ignoreMemory;  
    NSTimeInterval _autoPlayTimeInterval;
    
@public
    DDTimer *_timer;
    
@private
	id _delegate;		
}

@property (nonatomic,retain) UIPageControl *pageCtrl;
@property (assign)    id <DDImagePageScrollViewDelegate> delegate;
@property (nonatomic) BOOL roundRectEnabled;     //图片是否带圆角   default is NO //PS:如果此参数为YES，则背景色必须为clearcolor //PS: 如果使用圆角图，则缩放大图的时候，会有像素损失
@property (nonatomic) BOOL cacheEnabled;         //是否使用图片缓存  default is NO
@property (nonatomic) BOOL tapEnabled;           //是否可以点击图片  default is NO
@property (nonatomic) BOOL zoomEnabled;          //图片是否可以缩放  default is NO
@property (nonatomic) BOOL pageCtrlEnabled;      //是否可以显示并使用pagectrl default is YES
@property (nonatomic) BOOL circleEnabled;        //是否首尾相连循环轮播 default is NO //PS: 此参数必须初始化时指定，且中途不可以切换
@property (nonatomic) BOOL ignoreMemory;         //是否忽略内存，default is YES //用于页数不多的情况下，滑动以后不做任何释放，为了保证页面使用的最流畅效果。
@property (nonatomic) NSTimeInterval autoPlayTimeInterval; //自动播放时间间隔 default is 0 单位秒，默认不自动播放，如果次属性>=0则自动播放启动

@property (nonatomic, retain) NSArray *imageURLs; //内部图片的url数组，也可以用于外部判断及调用使用

//pagectrol水平对齐方式 默认居中
@property(nonatomic)  enum pageCtrolhorizontalAlignment  pageCtrolalignment;

//刷新页面，并指定从那页开始显示
//PS:imageurls是由图片的URL组成的数组, 可以为网络路径也可以为本地路径
- (void)refreshPagesForImageURLs:(NSArray*)imageurls startIndex:(NSInteger)index;

//刷新页面的第二种方法，如果传入的是一组uiimage的数组，则本类把这些图片保存到doucment里，然后显示，当下次refresh时，覆盖本次图片
//PS:目前只支持jpg和png两种，其他格式都自动转变为jpg，
//PS:imageType为 @"jpg" 或 @"png"，注意:全部小写，并且不带"." 此参数必须存在，否则不刷新, //所有图片必须同一个类型
- (void)refreshPagesForImages:(NSArray*)images imageType:(NSString*)type startIndex:(NSInteger)index;

//滚动到指定index对应的页面，用于外部计时器驱动自动滚动，或者外部点击滚动
- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated needReturn:(BOOL)bReturn;    

//获取当前页的图片
- (UIImage*)gotCurrentPageImage;

- (NSInteger)pageIndexForScrollIndex:(NSInteger)scrollIndex; //根据页面的scrollIndex找到对应的页面index;
- (void)loadPageForScrollIndex:(NSInteger)scrollIndex;

- (void)setScrollViewFrame:(CGRect)frame;

@end
