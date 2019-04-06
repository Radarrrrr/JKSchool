//
//  DDImagePageScrollView.m
//  DangDangHD
//
//  Created by Radar on 12-11-16.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//
// 


#import "DDImagePageScrollView.h"


#pragma mark - in use properties and functions
@interface DDImagePageScrollView ()

@property (nonatomic) NSInteger currentScrollIndex;  //当前scrollview中页面的index
@property (nonatomic, retain) NSArray *imageURLs;
@property (nonatomic, retain) NSMutableArray *pages;

- (void)updatePageForScrollIndex:(NSInteger)scrollIndex;

- (void)clearPageForScrollIndex:(NSInteger)scrollIndex;

- (void)loadAllPages;
- (void)clearAllPages;


- (void)scrollToScrollIndex:(NSInteger)scrollIndex animated:(BOOL)animated needReturn:(BOOL)bReturn;//滚动到指定scrollindex对应的页面
- (void)fixPositionForCircle; //在循环状态下，修正滚动到了边界的位置，保证滚动的流畅

//供子类重构来实现一些特殊的东西
- (DDURLImageView*)createImageViewWithFrame:(CGRect)frame;
- (UIColor*)getColorForSelectedPage;
- (UIColor*)getColorForNotSelectedPage;
@end


@implementation DDImagePageScrollView

@synthesize delegate = _delegate;
@synthesize imageURLs = _imageURLs;
@synthesize pages = _pages;
@synthesize currentScrollIndex = _currentScrollIndex;
@dynamic roundRectEnabled;
@synthesize cacheEnabled = _cacheEnabled; 
@synthesize tapEnabled = _tapEnabled;
@synthesize zoomEnabled = _zoomEnabled;
@synthesize pageCtrlEnabled = _pageCtrlEnabled;
@synthesize circleEnabled = _circleEnabled;
@synthesize ignoreMemory = _ignoreMemory;
@dynamic autoPlayTimeInterval;

- (void)setup {
    _currentScrollIndex = 0;
    _roundRectEnabled = NO;
    _cacheEnabled = NO;
    _tapEnabled = NO;
    _zoomEnabled = NO;
    _pageCtrlEnabled = YES;
    _circleEnabled = NO;
    _ignoreMemory = YES;
    _autoPlayTimeInterval = 0;
    _pageCtrolalignment=center;

        //add timer
    _timer = [[DDTimer alloc] init];
    _timer.delegate = self;
    _timer.timeInterval = 0;
    _timer.bRepeat = YES;
    [_timer stopTimer];

        // Initialization code.
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.clipsToBounds = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop =NO;
    [self addSubview:_scrollView];

    //add _spinner
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = _scrollView.center;
    _spinner.hidesWhenStopped = YES;
    [self addSubview:_spinner];
    [_spinner release];
    [_spinner startAnimating];
    [_spinner setHidden:YES];
        
    //add pagectrl
    _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    _pageCtrl.hidesForSinglePage = YES;
    _pageCtrl.backgroundColor = [UIColor clearColor];
    _pageCtrl.userInteractionEnabled = NO;
    _pageCtrl.numberOfPages = 1;
    [self addSubview:_pageCtrl];
    
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0){
        _pageCtrl.pageIndicatorTintColor = [self getColorForNotSelectedPage];
        _pageCtrl.currentPageIndicatorTintColor = [self getColorForSelectedPage];
    }
 
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc 
{
    if(_scrollView)
    {
        _scrollView.delegate = nil;
        [_scrollView release];
    }
    if(_timer)
    {
        _timer.delegate = nil;
        [_timer stopTimer];
        [_timer release];
    }
    
	[_imageURLs release];
    
    if(_pages)
    {
        if([_pages count] != 0)
        {
            for(UIScrollView *pscrol in _pages)
            {
                if([pscrol isKindOfClass:[UIScrollView class]])
                {
                    NSArray *subVs = [pscrol subviews];
                    if(subVs && [subVs count] != 0)
                    {
                        for(id dpage in subVs)
                        {
                            if([dpage isKindOfClass:[DDURLImageView class]])
                            {
                                DDURLImageView *ddpv = (DDURLImageView*)dpage;
                                ddpv.delegate = nil;
                            }
                        }
                    }
                }
            }
        }
        [_pages release];
    }
    [_pageCtrl release];
    [super dealloc];
}

- (void)setScrollViewFrame:(CGRect)frame
{
    _scrollView.frame = frame;
}

- (void)setRoundRectEnabled:(BOOL)rrEnabled
{
    _roundRectEnabled = rrEnabled;
    if(_roundRectEnabled)
    {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }
}

- (void)setAutoPlayTimeInterval:(NSTimeInterval)timeInterval
{
    _autoPlayTimeInterval = timeInterval;
    if(timeInterval == 0)
    {
        if(_timer)
        {
            [_timer stopTimer];
        }
    }
}

-(void)upDatePageCtrolalignment:(enum pageCtrolhorizontalAlignment)pagealignment
{
    if(pagealignment == right)
    {
        CGSize pointSize = [_pageCtrl sizeForNumberOfPages:_pageCtrl.numberOfPages];
        CGFloat page_x = self.frame.size.width-pointSize.width-10 ;
        
        CGRect rect=_pageCtrl.frame;
        rect.origin.x=page_x;
        rect.size.width=pointSize.width;
        _pageCtrl.frame=rect;
    
        if(_imageURLs.count <= 1) return;
        
//        UIImageView *_backView=[[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x-5, rect.origin.y+rect.size.height/4, rect.size.width+10, rect.size.height/2)];
//        _backView.backgroundColor=[UIColor clearColor];
//        UIImage *image=[[UIImage imageNamed:@"banner_switch_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(3, 15, 3, 15)];
//        [_backView setImage:image];
//        [self addSubview:_backView];
        [self bringSubviewToFront:_pageCtrl];
//        [_backView release];
    }
    else if (pagealignment == left)
    {
        CGSize pointSize = [_pageCtrl sizeForNumberOfPages:_pageCtrl.numberOfPages];
        CGFloat page_x = 10 ;
        
        CGRect rect=_pageCtrl.frame;
        rect.origin.x=page_x;
        rect.size.width=pointSize.width;
        _pageCtrl.frame=rect;
    }
    else
    {
        CGRect rect=CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
        _pageCtrl.frame=rect;
    }
}


#pragma mark -
#pragma mark in use functions
-(void)updatePageForScrollIndex:(NSInteger)scrollIndex
{
    //移动pagectrl的指示
    NSInteger pageIndex = [self pageIndexForScrollIndex:scrollIndex];
     _pageCtrl.currentPage = pageIndex;
    
    //刷新页面
	NSInteger count = [_pages count];
	
	//当前+前2+后2进行判断
	[self loadPageForScrollIndex:scrollIndex];
	
	if(scrollIndex-1 >= 0)
	{
		[self loadPageForScrollIndex:(scrollIndex-1)];
	}
	if(scrollIndex-2 >= 0)
	{
		[self clearPageForScrollIndex:(scrollIndex-2)];
	}
	
	if(scrollIndex+1 <= count-1)
	{
		[self loadPageForScrollIndex:(scrollIndex+1)];
	}
	if(scrollIndex+2 <= count-1)
	{
		[self clearPageForScrollIndex:(scrollIndex+2)];
	}
    
    //如果是循环播放，则额外读取一张边界图片
    if(_circleEnabled)
    {
        if(scrollIndex == 1)
        {
            [self loadPageForScrollIndex:(count-2)];
        }
        else if(scrollIndex == count-2)
        {
            [self loadPageForScrollIndex:1];
        }
    }
    
}
-(void)loadPageForScrollIndex:(NSInteger)scrollIndex
{
    NSInteger pageIndex = [self pageIndexForScrollIndex:scrollIndex];
    
    id page = [_pages objectAtIndex:scrollIndex];
	if([page isKindOfClass:[NSNull class]])
	{
		//init
		NSString *imageUrl = (NSString*)[_imageURLs objectAtIndex:pageIndex];
		
		float page_w = self.frame.size.width;
        float page_h = self.frame.size.height;
		CGRect pageRect = CGRectMake(page_w*scrollIndex, 0.0, page_w, page_h);
		
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:pageRect];
        scrollV.multipleTouchEnabled = YES;
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.showsVerticalScrollIndicator = NO;
        scrollV.delegate = self;
        [scrollV setMinimumZoomScale:minZoomScale];
        [scrollV setMaximumZoomScale:maxZoomScale];
        [scrollV setZoomScale:1.0];
        
		DDURLImageView *pageView = [self createImageViewWithFrame:CGRectMake(0.0, 0.0, page_w, page_h)];
		pageView.delegate = self;
        pageView.bShowSpinner = NO;
        pageView.bRoundRect = NO;
        pageView.bUseUrlCache = _cacheEnabled;
        pageView.userInteractionEnabled = _tapEnabled;
        pageView.tag = 100;
        pageView.tagString = [NSString stringWithFormat:@"%ld", (long)pageIndex];
        [scrollV addSubview:pageView];
        
        //检测imageUrl是否是网络图片，如果是，则读取网络，否则，读取本地图片file路径
        NSRange rangehttp  = [imageUrl rangeOfString:@"http://"];
		NSRange rangehttps = [imageUrl rangeOfString:@"https://"];
		if(rangehttp.length == 0 && rangehttps.length == 0) 
		{
			//不是网络图片而是本地图片
            UIImage *image = [UIImage imageWithContentsOfFile:imageUrl];
            [pageView updateLayer:image];
		}
        else
        {
            [pageView startLoading:imageUrl];
        }
  
		[_pages replaceObjectAtIndex:scrollIndex withObject:scrollV];
		[_scrollView addSubview:scrollV];
        
        [scrollV release];
	}
    else if([page isKindOfClass:[UIScrollView class]])
    {
        //判断当前index的page是否zoom的比例不是1.0, 如果不是，则恢复为1.0
        UIScrollView *tpage = (UIScrollView*)page;
        if(tpage.zoomScale != 1.0)
        {
            [tpage setZoomScale:1.0];
        }
    }
}

//勿删，否则DDURLImageView的菊花不再正中间 [杨玉彬 2014.9.19］
- (DDURLImageView*)createImageViewWithFrame:(CGRect)frame
{
    return [[[DDURLImageView alloc] initWithFrame:frame] autorelease];
}

- (DDURLImageView*)createImageView{
    return [[[DDURLImageView alloc] init] autorelease];
}

- (UIColor*)getColorForSelectedPage
{
    return RGB(255, 70, 60);
}
- (UIColor*)getColorForNotSelectedPage
{
    return [UIColor colorWithRed:(float)220/255 green:(float)220/255 blue:(float)220/255 alpha:.7];
}

-(void)clearPageForScrollIndex:(NSInteger)scrollIndex
{	
    if(_ignoreMemory) return;
    
    id page = [_pages objectAtIndex:scrollIndex];
	if([page isKindOfClass:[UIScrollView class]])
	{        
        DDURLImageView *ddpage = (DDURLImageView*)[page viewWithTag:100];
        ddpage.delegate = nil;
        [ddpage updateLayer:nil];
        [ddpage removeFromSuperview];
		
        [page removeFromSuperview];
		
		[_pages replaceObjectAtIndex:scrollIndex withObject:[NSNull null]];
	}
}

- (void)loadAllPages
{
    for(int i=0; i<[_pages count]; i++)
    {
        [self loadPageForScrollIndex:i];
    }
}
- (void)clearAllPages
{
    for(int i=0; i<[_pages count]; i++)
    {
        if(!_pages || [_pages count] == 0) return;
        
        id page = [_pages objectAtIndex:i];
        if(page && [page isKindOfClass:[UIScrollView class]])
        {        
            UIView *pageView = (UIView*)[page viewWithTag:100];
            if(pageView && [pageView superview])
            {
                [pageView removeFromSuperview];
            }
            
            [page removeFromSuperview];
            [_pages replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
}

- (NSInteger)pageIndexForScrollIndex:(NSInteger)scrollIndex
{
//    6,0,1,2,3,4,5,6,0
//    0,1,2,3,4,5,6,7,8
    
    NSInteger pindex;
    
    if(!_circleEnabled)
    {
        pindex = scrollIndex;
    }
    else
    {
        NSInteger count = [_imageURLs count];
        pindex = scrollIndex-1;
        
        if(pindex < 0)
        {
            pindex = count-1;
        }
        else if(pindex >= count)
        {
            pindex = 0;
        }
    }
    
    return pindex;
}

- (void)fixPositionForCircle
{
    //在循环状态下，修正滚动到了边界的位置，保证滚动的流畅
    if(!_circleEnabled) return;
    
    //NSInteger pcount = [_imageURLs count];
    NSInteger scount = [_pages count];
    
    if(_currentScrollIndex <= 0)
    {
        [self scrollToScrollIndex:(scount-2) animated:NO needReturn:NO];
    }
    else if(_currentScrollIndex >= scount-1)
    {
        [self scrollToScrollIndex:1 animated:NO needReturn:NO];
    }
}

-(void)scrollToScrollIndex:(NSInteger)scrollIndex animated:(BOOL)animated needReturn:(BOOL)bReturn
{
    _currentScrollIndex = scrollIndex;
    
    CGPoint contentOffset = _scrollView.contentOffset;
	float page_w = self.frame.size.width;
	contentOffset.x = _currentScrollIndex *page_w;
	
	[_scrollView setContentOffset:contentOffset animated:animated];
	
	[self updatePageForScrollIndex:_currentScrollIndex];
    
    if(bReturn)
    {
        //返回给代理当前的page编号 用程序自动滑动停止到这里
        NSInteger pageIndex = [self pageIndexForScrollIndex:_currentScrollIndex];
        if(self.delegate && [self.delegate respondsToSelector:@selector(ddImagePageScrollViewDidChangeToPageIndex:pageIndex:)])
        {
            [self.delegate ddImagePageScrollViewDidChangeToPageIndex:self pageIndex:pageIndex];
        }
    }
}




#pragma mark -
#pragma mark out use functions
-(void)refreshPagesForImageURLs:(NSArray*)imageurls startIndex:(NSInteger)index
{
    //stop waiting
    [_spinner stopAnimating];
    
	if(imageurls == nil || [imageurls count] == 0) return;
    NSInteger startIndex = index;
    
    //清空所有page
    [self clearAllPages];
    
    
    //如果只有一张图，则强制改为不循环，并且起始index强制设定为0
    if([imageurls count] == 1)
    {
        self.circleEnabled = NO;
        startIndex = 0;
    }
    
    
    //获取数据
	self.imageURLs = imageurls;
    
    //修改pagectrl的属性
    _pageCtrl.numberOfPages = [imageurls count];
    _pageCtrl.currentPage = startIndex;
    //更新对齐方式
    [self upDatePageCtrolalignment:_pageCtrolalignment];

    //设定pagectrlor的显示状态
    if([imageurls count] <= 1)
    {
        _pageCtrl.hidden = YES;
    }
    else
    {
        if(_pageCtrlEnabled)
        {
            _pageCtrl.hidden = NO;
        }
        else
        {
            _pageCtrl.hidden = YES;
        }
    }
    
	//create pages
	NSMutableArray *pagesArr = [[[NSMutableArray alloc] init] autorelease];
	
	float content_w = 0.0;
	float page_w = self.frame.size.width;
	
    //如果循环开启，则队列前后分别多加1个空白page
//----- qz 然后以后轮播图每次下载图片都多下载两张？而且下载的还是1242宽度的6p图片 这里后续要修改
    NSInteger pageCount = [_imageURLs count];
    if(_circleEnabled)
    {
        pageCount += 2;
    }
    
	for(int i=0; i<pageCount; i++)
	{
		[pagesArr addObject:[NSNull null]];
		content_w += page_w;
	}
	
	self.pages = pagesArr;
	_scrollView.contentSize = CGSizeMake(content_w, self.frame.size.height);
    
    
    //忽略内存，则把所有页面一次性全部读取完毕
    if(_ignoreMemory)
    {
        [self loadAllPages];
    }
    
	//跳转到对应页面，如果不忽略内存，则顺便读取该页内容
	[self scrollToPageIndex:startIndex animated:NO needReturn:YES];
    
    //开启计时器
    if(_autoPlayTimeInterval != 0)
    {
        [_timer stopTimer];
        _timer.timeInterval = _autoPlayTimeInterval;
        [_timer startTimer];
    }
}

- (void)refreshPagesForImages:(NSArray*)images imageType:(NSString*)type startIndex:(NSInteger)index
{
    if(!images || [images count] == 0) return;
    
    //存储图片到本地，并获得本地路径的数组
    NSMutableArray *savedImagesURLs = [[[NSMutableArray alloc] init] autorelease];
    for(int i=0; i<[images count]; i++)
    {
        UIImage *image = [images objectAtIndex:i];
        
        NSData *imageData;
        if([type compare:@"png"] == NSOrderedSame) //png
        {
            imageData = UIImagePNGRepresentation(image);
        }
        else //jpg & others
        {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
        
        NSString *imageName = [NSString stringWithFormat:@"dd_page_scroll_temp_use_%d.%@", i, type];
        
        
        if(!imageData) continue;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
        
        BOOL bSuccess = [imageData writeToFile:imagePath atomically:YES];
        if(bSuccess)
        {
            [savedImagesURLs addObject:imagePath];
        }
    }
   
    //刷新页面
    [self refreshPagesForImageURLs:savedImagesURLs startIndex:index];
    
}

-(void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated needReturn:(BOOL)bReturn
{
    //计算当前要调转到的_currentScrollIndex
    NSInteger pcount = [_imageURLs count];
    NSInteger scount = [_pages count];
    if(_circleEnabled)
    {
        if(pageIndex == 0 && _currentScrollIndex == scount-2)
        {
            _currentScrollIndex += 1;
        }
        else if(pageIndex == pcount-1 && _currentScrollIndex == 1)
        {
            _currentScrollIndex -= 1;
        }
        else
        {
            _currentScrollIndex = pageIndex+1;
        }
    }
    else
    {
        _currentScrollIndex = pageIndex;
    }
    

    [self scrollToScrollIndex:_currentScrollIndex animated:animated needReturn:bReturn];
    
    //如果是循环，并且不动画，就立即修正一下位置
    if(_circleEnabled && !animated)
    {
        [self fixPositionForCircle];
    }
}

//获取当前页的图片
- (UIImage*)gotCurrentPageImage
{
    if(!_pages || [_pages count] == 0) return nil;
    if(_currentScrollIndex < 0 || _currentScrollIndex >= [_pages count]) return nil;
    
    UIScrollView *pscrol = [_pages objectAtIndex:_currentScrollIndex];
    if(!pscrol || ![pscrol isKindOfClass:[UIScrollView class]]) return nil;
    
    NSArray *subVs = [pscrol subviews];
    if(!subVs || [subVs count] == 0) return nil;
    
    for(id dpage in subVs)
    {
        if([dpage isKindOfClass:[DDURLImageView class]])
        {
            DDURLImageView *ddpv = (DDURLImageView*)dpage;
            return ddpv.photo;
        }
    }
    
    return nil;
}




#pragma mark -
#pragma mark delegate functions
//UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{    
    if(scrollView == _scrollView) return nil;
    
    if(!_zoomEnabled) return nil;
    
    DDURLImageView *imagePageView = (DDURLImageView*)[scrollView viewWithTag:100];
    return imagePageView;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != _scrollView) return;
    
	//计算当前content offset, 用以计算当前处在哪个page上
	float page_w = self.frame.size.width;
	_currentScrollIndex = floor((_scrollView.contentOffset.x - page_w/2)/page_w)+1;//_scrollView.contentOffset.x/page_w;
	//NSLog(@"scrollIndex : %d", _currentScrollIndex);
	
	//刷新一下当前页面image
    if(!_circleEnabled)
    {
        [self updatePageForScrollIndex:_currentScrollIndex];
	}
    else
    {
        NSInteger scount = [_pages count];
        
        if(_currentScrollIndex <= 0 || _currentScrollIndex >= scount-1)
        {
            [self fixPositionForCircle];
        }
        else
        {
            [self updatePageForScrollIndex:_currentScrollIndex];
        }
    }
    
    //重启计时器
    if(_autoPlayTimeInterval != 0)
    {
        if(_timer)
        {
            [_timer startTimer];
        }
    }
    
    
	//返回给代理当前的page编号 用手滑动停止到这里
    NSInteger pagaIndex = [self pageIndexForScrollIndex:_currentScrollIndex];
	if(self.delegate && [self.delegate respondsToSelector:@selector(ddImagePageScrollViewDidChangeToPageIndex:pageIndex:)])
	{
		[self.delegate ddImagePageScrollViewDidChangeToPageIndex:self pageIndex:pagaIndex];
	}
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //当setContentOffset自动滚动结束，判断当前是否 _circleEnabled ，是否处在边界上，如果是，则切换到正确位置
    if(_circleEnabled)
    {
        [self fixPositionForCircle];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //用手滑动开始在这里
    //关闭计时器
    if(_timer)
    {
        [_timer stopTimer];
    }
}

//DDURLImageViewDelegate
-(void)ddURLImageViewDidLoad:(DDURLImageView*)ddURLImageView image:(UIImage*)image
{
    NSInteger index = [ddURLImageView.tagString integerValue];
    
    //返回给代理读取完毕的page页相关数据
	if(self.delegate && [self.delegate respondsToSelector:@selector(ddImagePageScrollViewDidFinishLoadingPage:finishPageIndex:finishImage:)])
	{
		[self.delegate ddImagePageScrollViewDidFinishLoadingPage:self finishPageIndex:index finishImage:image];
	}
}
-(void)ddURLImageViewDidTap:(DDURLImageView*)ddURLImageView atPoint:(CGPoint)atPoint image:(UIImage*)image
{
    NSInteger index = [ddURLImageView.tagString integerValue];
    NSString *imageURL = [_imageURLs objectAtIndex:index];

    //返回给代理选择的page页相关数据
	if(self.delegate && [self.delegate respondsToSelector:@selector(ddImagePageScrollViewDidTapInPage:pageIndex:atPoint:pageImage:pageImageURL:)])
	{
		[self.delegate ddImagePageScrollViewDidTapInPage:self pageIndex:index atPoint:atPoint pageImage:image pageImageURL:imageURL];
	}
}

- (void)ddURLImageViewDidTouchBegain:(DDURLImageView *)ddURLImageView
{
    //关闭计时器
    if(_timer)
    {
        [_timer stopTimer];
    }
}
- (void)ddURLImageViewDidTouchEnd:(DDURLImageView *)ddURLImageView
{
    //重启计时器
    if(_autoPlayTimeInterval != 0)
    {
        if(_timer)
        {
            [_timer startTimer];
        }
    }
}


//DDTimerDelegate
-(void)ddTimerDidFired:(DDTimer*)ddTimer
{
    //滚动到下一张
    NSInteger scount = [_pages count];
    
    _currentScrollIndex += 1;
    
    if(!_circleEnabled)
    {
        if(_currentScrollIndex > scount-1)
        {
            _currentScrollIndex = 0;
        }
    }
    else
    {
        if(_currentScrollIndex > scount-1) //处理有时候会出现编号错误导致数组读取越界的问题
        {
            [self fixPositionForCircle];
            return;
        }
    }
    
    [self scrollToScrollIndex:_currentScrollIndex animated:YES needReturn:YES];
    
}

@end
