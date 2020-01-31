//
//  CMSHornView.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "CMSHornView.h"


@interface CMSHornView ()

@property (nonatomic, strong) DDTimer *timer; 
@property (nonatomic, strong) UIButton *curButton;   //指向当前可见的button
@property (nonatomic, strong) UIButton *nextButton;   //指向当前可见的button



- (NSArray*)convertDatasFromSource:(id)source; //转化原始数据数组为组件内部使用的数组结构

@end


@implementation CMSHornView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        //add timer
        _timer = [[DDTimer alloc] init];
        _timer.delegate = self;
        _timer.bRepeat = YES;
        _timer.timeInterval = 3;
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    //如果是从后一页面倒回来的，就不刷新了
    if(ARRAYVALID(self.subviews)) return;
        
    if(!_hornDatas || [_hornDatas count] == 0) 
    {
        //如果小喇叭没数据，那么就隐藏
        CGRect sframe = self.frame;
        sframe.size.height = 0;
        self.frame = sframe;
        
        return;
    }
    
    //添加小喇叭图标
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(20, (self.frame.size.height-14)/2, 28, 14)];
    iconV.image = [UIImage imageNamed:@"icon_horn"];
    [self addSubview:iconV];
    
   
    //创建小喇叭
    self.curButton = [self createButtonForIndex:0];
    if(!_curButton) return;
    
    [self addSubview:_curButton];
    
    //开启计时器
    if([_hornDatas count] > 1)
    {
        [_timer startTimer];
    }
}




#pragma mark -
#pragma mark in use functions
- (NSArray*)convertDatasFromSource:(id)source
{
    if(!source || ![source isKindOfClass:[NSArray class]]) return nil;
    
    NSArray *sourceArr = (NSArray*)source;
    if([sourceArr count] == 0) return nil;
    
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    
    for(NSDictionary *dic in sourceArr)
    {
        if(![dic isKindOfClass:[NSDictionary class]]) continue;
        
        NSString *link_word = (NSString*)[dic objectForKey:@"link_word"];
        NSString *lini_url  = (NSString*)[dic objectForKey:@"link_url"];
        
        if(link_word)
        {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setObject:link_word forKey:@"link_word"];
            
            if(lini_url && [lini_url compare:@""] != NSOrderedSame)
            {
                [data setObject:lini_url forKey:@"link_url"];
            }
            
            [datas addObject:data];
        }
    }
    
    return datas;
}

- (UIButton*)createButtonForIndex:(NSInteger)index
{
    if(!_hornDatas || [_hornDatas count] == 0) return nil;
    
    //[{"link_word":"xxx", "link_url":"xxx"},...]
    NSDictionary *data = [_hornDatas objectAtIndex:index];
    if(!data) return nil;
    
    NSString *link_word = (NSString*)[data objectForKey:@"link_word"];
//    NSString *link_url   = (NSString*)[data objectForKey:@"link_url"];
    
    //创建显示按钮
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setBackgroundColor:[UIColor clearColor]];
    showBtn.frame = CGRectMake(20+28+10, 0, self.frame.size.width-70, self.frame.size.height);
    showBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    showBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    showBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [showBtn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    [showBtn setTitleColor:[UIColor colorWithRed:(float)50/255 green:(float)220/255 blue:(float)210/255 alpha:1.0] forState:UIControlStateHighlighted];
    [showBtn setTitle:link_word forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(hornBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    showBtn.tag = index;
    
    return showBtn;
}


- (void)hornBtnAction:(UIButton*)btn
{
    if(!_hornDatas || [_hornDatas count] == 0) return;
    
    //[{"link_word":"xxx", "link_url":"xxx"},...]
    NSDictionary *data = [_hornDatas objectAtIndex:btn.tag];
    if(!data) return;

    NSString *link_url   = (NSString*)[data objectForKey:@"link_url"];
    
    //走控制中心
    [DDCenter actionForLinkURL:link_url];
}




#pragma mark -
#pragma mark delegate functions
//DDTimerDelegate
-(void)ddTimerDidFired:(DDTimer*)ddTimer
{
    if(!_curButton) return;
    
    NSInteger curIndex = _curButton.tag;
    NSInteger nextIndex = curIndex+1;
    if(nextIndex >= [_hornDatas count])
    {
        nextIndex = 0;
    }
    
    //先创建下一个按钮
    self.nextButton = [self createButtonForIndex:nextIndex];
    if(!_nextButton)
    {
        [_timer stopTimer];
        return;
    }
    
    //把下个按钮添加到下面
    CGRect nframe = _nextButton.frame;
    nframe.origin.y = nframe.size.height;
    _nextButton.frame = nframe;
    _nextButton.alpha = 0.0;
    [self addSubview:_nextButton];
    
    //在两个按钮之间做动画
    CGRect cframe = _curButton.frame;
    
    cframe.origin.y = -cframe.size.height;
    nframe.origin.y = 0;
    
    [UIView animateWithDuration:0.35 
                     animations:^{
                         self->_curButton.frame = cframe;
                         self->_nextButton.frame = nframe;
                         self->_curButton.alpha = 0.0;
                         self->_nextButton.alpha = 1.0;
                     } 
                     completion:^(BOOL finished){
                         if(self->_curButton && [self->_curButton superview])
                         {
                             [self->_curButton removeFromSuperview];
                             self.curButton = nil;
                         }
                         self.curButton = self->_nextButton;
                         self.nextButton = nil;
                     }
     ];
    
}




@end
