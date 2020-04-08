//
//  NoticeCard.m
//  JKSchool
//
//  Created by Radar on 2020/2/20.
//  Copyright © 2020年 radar. All rights reserved.
//

#import "NoticeCard.h"

@implementation NoticeCard

- (id)initWithFrame:(CGRect)frame data:(NSDictionary*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBS(250);
        self.clipsToBounds = YES;
        
        [RDFunction addRadiusToView:self radius:6];
//        [JKFunction addShadowToView:self];
        
        //add elements
        [self addElementsWithData:data];
        
    }
    return self;
}

- (void)addElementsWithData:(NSDictionary*)data
{
//    @{@"id":@"1", 
//      @"title":@"春节放假通知", 
//      @"content":@"春节春节放假通知春节放假通知春节放假通知春节放假通知春节放假通知放假通知", 
//      @"school":@"双桥区东方星民族艺术教育幼儿园",
//      @"time":@"2019-01-01"
//      }
    
    if(!DICTIONARYVALID(data)) return;

    //add title
    UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    tLabel.userInteractionEnabled = NO;
    tLabel.backgroundColor = [UIColor clearColor];
    tLabel.textAlignment = NSTextAlignmentLeft;
    tLabel.font = FONT_B(15.0);
    tLabel.textColor = COLOR_TEXT_B;
    tLabel.text = [data objectForKey:@"title"];
    [self addSubview:tLabel];
    
    //add content
    NSString *content = [data objectForKey:@"content"];
    float oneH = [JKFunction getHeightForString:@"单行内容" font:FONT(12.0) width:self.frame.size.width-20];
    NSInteger lines = [RDFunction getLinesForString:content font:FONT(12.0) width:self.frame.size.width-20];
    
    NSInteger useLs = lines;
    if(lines>3) useLs = 3;
    
    float conHeight = oneH * useLs;
    //TO DO: 接下来要给UILabel增加类别方法，自动fix高度的变化。   
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(10, POS_D(tLabel, 10), self.frame.size.width-20, conHeight)];
    textL.numberOfLines = 3;
    textL.backgroundColor = [UIColor clearColor];
    textL.userInteractionEnabled = NO;
    textL.textAlignment = NSTextAlignmentLeft;
    textL.font = FONT(12.0);
    textL.textColor = COLOR_TEXT_C;
    textL.text = content;
    [self addSubview:textL];
    
    //add school
    UILabel *schoolL = [[UILabel alloc] initWithFrame:CGRectMake(10, POS_D(textL, 10), 200, 16)];
    schoolL.userInteractionEnabled = NO;
    schoolL.backgroundColor = [UIColor clearColor];
    schoolL.textAlignment = NSTextAlignmentLeft;
    schoolL.font = FONT(10.0);
    schoolL.textColor = COLOR_TEXT_C;
    schoolL.text = [data objectForKey:@"school"];
    [self addSubview:schoolL];
    
    //add time
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100-10, POS_D(textL, 10), 100, 16)];
    timeL.userInteractionEnabled = NO;
    timeL.backgroundColor = [UIColor clearColor];
    timeL.textAlignment = NSTextAlignmentRight;
    timeL.font = FONT(10.0);
    timeL.textColor = COLOR_TEXT_C;
    timeL.text = [data objectForKey:@"time"];
    [self addSubview:timeL];
    
    //卡片高度
    float cardHeight = CGRectGetMaxY(schoolL.frame) + 10;
    
    //add backBtn
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, self.frame.size.width, cardHeight);
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.tagData = data;
    [backBtn addTarget:self action:@selector(noticeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    [self sendSubviewToBack:backBtn];
    
    //修改卡片自身高度
    [JKFunction modifyFrameFor:self toX:nil toY:nil toW:nil toH:STR_F(cardHeight)];
}

- (void)noticeAction:(UIButton *)btn
{
    //根据btn.tagData组合跳转链接，进入通知详情页
    //btn.tagData:
    //    @{@"id":@"1", 
    //      @"title":@"春节放假通知", 
    //      @"content":@"春节春节放假通知春节放假通知春节放假通知春节放假通知春节放假通知放假通知", 
    //      @"school":@"双桥区东方星民族艺术教育幼儿园",
    //      @"time":@"2019-01-01"
    //      }
    
    if(!DICTIONARYVALID(btn.tagData)) return;
    
    NSString *nid = [(NSDictionary*)btn.tagData objectForKey:@"id"];
    if(!STRVALID(nid)) return;
    
    NSString *linkUrl = [NSString stringWithFormat:@"notice://id=%@", nid];
    [DDCenter actionForLinkURL:linkUrl];
}

@end
