//
//  RDIconsView.m
//  RDIconsViewDemo
//
//  Created by Radar on 2020/2/1.
//  Copyright © 2020年 Radar. All rights reserved.
//

#import "RDIconsView.h"
#import "UIImageView+URLImage.h"
#import "UIButton+Color.h"
#import "RDSlidePageControl.h"


#define IVSCR_W      [UIScreen mainScreen].bounds.size.width
#define IV_ICON_W    IVSCR_W/5.0
#define IV_ICON_H    IV_ICON_W

#define IV_ICON_IMG_OFFSET 17.5


@interface RDIconsView ()

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) RDSlidePageControl *pageControl;
@property (nonatomic, strong) void (^iconPressedBlock)(NSDictionary* icon);

@end


@implementation RDIconsView

- (id)init
{    
    CGRect frame = CGRectMake(0, 0, IVSCR_W, IV_ICON_H + 20); //此模块一般都会嵌入列表使用，所以默认位置0，0，如果有需要更改，自行外面修改即可
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)modifyFrameFor:(UIView *)view toX:(NSString *)x toY:(NSString *)y toW:(NSString *)w toH:(NSString*)h
{
    //修改一个view及其子类的frame，用于多次更改位置或大小，又不是每次所有属性全改的情况
    //参数为用float类型的数据做成NSString类型输入，如果不需要改，就直接输入nil
    if(!view) return;
    if(!x && !y && !w && !h) return;
    
    CGRect nframe = view.frame;
    if(x && ![x isEqualToString:@""])
    {
        nframe.origin.x = [x floatValue];
    }
    if(y && ![y isEqualToString:@""])
    {
        nframe.origin.y = [y floatValue];
    }
    if(w && ![w isEqualToString:@""])
    {
        nframe.size.width = [w floatValue];
    }
    if(h && ![h isEqualToString:@""])
    {
        nframe.size.height = [h floatValue];
    }
    
    view.frame = nframe;
}

- (void)handleIconPressed:(void (^)(NSDictionary *icon))action
{
    //接一下block
    self.iconPressedBlock = action;
}

- (void)setIcons:(NSArray *)icons
{
    //icons: [{"icon_img":"xxx", "icon_name":"xxx", "link_url":"xxxx"},...] 
    if(!icons || icons.count == 0) return;
    
    //默认set只使用一次，如果再次调用，则会清空所有内容重新绘制
    if(_contentView && [_contentView superview])
    {
        [_contentView removeFromSuperview];
        self.contentView = nil;
    }
    
    if(_pageControl && [_pageControl superview])
    {
        [_pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    
    //计算自己的高度，以及scrollview的尺寸
    float cntW = self.frame.size.width; //默认设定scrollview和self是相同尺寸
        
    //根据icons数量，计算并设定容器尺寸
    NSInteger count = icons.count;
    
    NSInteger pc = count/10; //页数
    if(count%10 != 0) pc += 1;

    float cw = cntW * pc; //容器宽
    
    float iconH = IV_ICON_H;
    float ch = iconH*2 + 20;
    
    //计算容器多高
    if(icons.count <= 5) //如果少于等于5个icon，则只有一行
    {
        ch = iconH + 20;
    }
    
    //修改自己的尺寸
    [self modifyFrameFor:self toX:nil toY:nil toW:nil toH:[NSString stringWithFormat:@"%f", ch]];
        
    //添加容器 
    self.contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.scrollEnabled = YES;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.contentSize = CGSizeMake(cw, ch);
    [self addSubview:_contentView];

    //添加pagecontroll
    if(icons.count > 10) //icon数量超过两行10个以后，才会出现pagecontrol
    {
        float pcW = IV_ICON_W-26;
        
        self.pageControl = [[RDSlidePageControl alloc] initWithFrame:CGRectMake((IVSCR_W-pcW)/2, self.frame.size.height-10, pcW, 3)];
        [_pageControl bindingToHostScrollView:_contentView];
        [self addSubview:_pageControl];
        [self bringSubviewToFront:_pageControl];
    }
    
    
    //添加icons上去
    for(int i=0; i<icons.count; i++)
    {
        //生成对应的iconbtn
        NSDictionary *icon = [icons objectAtIndex:i];
        UIButton *iconBtn = [self createIconButtonForData:icon];
        
        float posX = 0.0;
        float posY = 10.0;
        
        //计算iconbtn的位置并摆放
        //icon所在第几页
        int pn = i/10; 
        
        //页面基础x
        posX = pn * cntW;
        
        //icon所在页面的第几个位置
        int ip = i%10; //0~9
        if(ip <= 4) //第一行 0～4
        {
            posX = posX + IV_ICON_W*ip;
            posY = 10.0;
        }
        else    //第二行 5～9
        {
            posX = posX + IV_ICON_W*(ip-5);
            posY = 10 + IV_ICON_H;
        }
        
        //如果不够5个，重新计算一下位置，平均排开
        if(icons.count <= 4) //ip: 0~3
        {
            float evaW = (float)(cntW/icons.count); //每一个按钮区域所占的均分宽度
            float off = (evaW - IV_ICON_W)/2.0; //第一个按钮的偏移量
            posX = off + evaW*ip;
        }
        
        //给iconBtn设定位置
        iconBtn.frame = CGRectMake(posX, posY, IV_ICON_W, IV_ICON_H);
        
        //添加到容器上去
        [_contentView addSubview:iconBtn];
    }
}


- (UIButton *)createIconButtonForData:(NSDictionary*)iconDic
{
    //{"icon_img":"xxx", "icon_name":"xxx", "link_url":"xxxx"}
    if(!iconDic || [iconDic count] == 0) return nil;
    
    //创建button
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(0, 0, IV_ICON_W, IV_ICON_H);
    iconBtn.backgroundColor = [UIColor clearColor];
    iconBtn.tagData = iconDic;
    [iconBtn addTarget:self action:@selector(iconAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //放上图片
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(IV_ICON_IMG_OFFSET, 10, IV_ICON_W-IV_ICON_IMG_OFFSET*2, IV_ICON_W-IV_ICON_IMG_OFFSET*2)];
    iconV.userInteractionEnabled = NO;
    iconV.backgroundColor = [UIColor clearColor];
    [iconV loadImage:[iconDic objectForKey:@"icon_img"]];
    [iconBtn addSubview:iconV];
    
    //放上文字
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconV.frame)+5, IV_ICON_W, 20)];
    nameL.userInteractionEnabled = NO;
    nameL.backgroundColor = [UIColor clearColor];
    nameL.textColor = [UIColor colorWithRed:(float)100.0/255.0 green:(float)100.0/255.0 blue:(float)100.0/255.0 alpha:1.0];
    nameL.font = [UIFont systemFontOfSize:12.0];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.text = [iconDic objectForKey:@"icon_name"];
    [iconBtn addSubview:nameL];
    
    return iconBtn;
}

- (void)iconAction:(UIButton *)iconBtn
{
    //返回给上层icon点击及数据
    if(self.iconPressedBlock)
    {
        self.iconPressedBlock((NSDictionary*)iconBtn.tagData);
    }
}


@end
