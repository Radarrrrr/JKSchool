//
//  RDSlidePageControl.m
//  RDIconsViewDemo
//
//  Created by Radar on 2020/2/8.
//  Copyright © 2020年 Radar. All rights reserved.
//

#import "RDSlidePageControl.h"

@interface  RDSlidePageControl ()

@property (nonatomic, strong) UIView *slider; //滑块
@property (nonatomic, weak) UIScrollView *hostScrollView; //绑定宿主的scrllview，用作监听位移

@end


@implementation RDSlidePageControl

- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        self.userInteractionEnabled = NO;
        
        [self addRadiusToView:self radius:frame.size.height/2.0];
        
        //添加滑块
        self.slider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, frame.size.height)];
        _slider.backgroundColor = [UIColor colorWithRed:9.0f/255.0f green:185.0f/255.0f blue:169.0f/255.0f alpha:1.0f];
        [self addRadiusToView:_slider radius:frame.size.height/2.0];
        [self addSubview:_slider];
        
    }
    return self;
}

- (void)setChuteColor:(UIColor *)chuteColor
{
    if(!chuteColor) return;
    self.backgroundColor = chuteColor;
}
- (UIColor *)chuteColor
{
    return self.backgroundColor;
}

- (void)setSliderColor:(UIColor *)sliderColor
{
    if(!sliderColor) return;
    self.slider.backgroundColor = sliderColor;
}
- (UIColor *)sliderColor
{
    return self.slider.backgroundColor;
}

- (void)dealloc
{    
    if(_hostScrollView)
    {
        [self removeKVOfromHost];
    }
}


- (void)addRadiusToView:(UIView*)view radius:(float)radius
{
    if(!view) return;
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

//移动滑块根据百分比
- (void)moveSlider:(float)percent
{
    //0.0~1.0
    if(percent < 0.0 || percent > 1.0) return;
    
    float toX = (self.frame.size.width-_slider.frame.size.width) * percent;
    
    CGRect nframe = _slider.frame;
    nframe.origin.x = toX;
    _slider.frame = nframe;
}


//添加KVO，监听宿主UIScrollView的滚动比例
- (void)addKVOtoHost
{
    [self.hostScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
}
- (void)removeKVOfromHost
{
    [self.hostScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(object == self.hostScrollView && [keyPath isEqualToString:@"contentOffset"]) 
    {
        float totalOff = fabs(_hostScrollView.contentSize.width - _hostScrollView.frame.size.width);
        float curtOff  = fabs(_hostScrollView.contentOffset.x);
        if(totalOff == 0.0) return;
        
        float percent = (float)curtOff/totalOff; //滚动偏移量
        [self moveSlider:percent];
        
        return;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


- (void)bindingToHostScrollView:(UIScrollView *)scrollView; //把本模块绑定到宿主的scrollView上，监听滑动比例，跟随滚动
{
    self.hostScrollView = scrollView;
    [self addKVOtoHost];
}


@end
