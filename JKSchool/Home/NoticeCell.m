//
//  NoticeCell.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "NoticeCell.h"
#import "NoticeCard.h"

@interface NoticeCell ()

@property (nonatomic, strong) UILabel *tLabel;

@end


@implementation NoticeCell

- (void)setCellStyle
{
    //设定cell的样式，所有的组件都放在 self.contentView 上面，做成全局变量，用以支持 setCellData 里边来修改组件的数值
    
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //add _tLabel
    self.tLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    _tLabel.backgroundColor = [UIColor clearColor];
    _tLabel.textAlignment = NSTextAlignmentLeft;
    _tLabel.font = [UIFont boldSystemFontOfSize:15.0];
    _tLabel.textColor = COLOR_TEXT_A;
    _tLabel.text = @"通知";
    [self.contentView addSubview:_tLabel];
    
    //add moreBtn
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(SCR_WIDTH-40-10, 0, 40, 40);
    moreBtn.backgroundColor = COLOR_CLEAR;
    moreBtn.titleLabel.font = FONT(12.0);
    [moreBtn setTitle:@"详情 >" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_TEXT_C forState:UIControlStateNormal];
    moreBtn.tagData = @"notice://";
    [moreBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    
    
}
- (NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
    /*data:
    @[
      @{@"id":@"1", 
        @"title":@"春节放假通知", 
        @"content":@"春节春节放假通知春节放假通知春节放假通知春节放假通知春节放假通知放假通知", 
        @"school":@"双桥区东方星民族艺术教育幼儿园",
        @"time":@"2019-01-01"
        },
      @{@"id":@"2", 
        @"title":@"有意义的寒假", 
        @"content":@"春节春节放假通知春节放假通知春节放假通知春节放假通知春节放假通知放假通知", 
        @"school":@"承德市第一中学",
        @"time":@"2019-01-01"
        },
      @{@"id":@"3", 
        @"title":@"今年春天很温暖", 
        @"content":@"春节春节放假通知春节放假通知春节放假通知春节放假通知春节放假通知放假通知", 
        @"school":@"金色摇篮幼儿园",
        @"time":@"2019-01-01"
        }
    */
    
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    if(!ARRAYVALID(data)) return nil;
    
    float cellH = POS_D(_tLabel, 10);
    
    for(NSDictionary *noti in data)
    {
        if(!DICTIONARYVALID(noti)) continue; //数据有问题不展示
        
        //用noti创建通知卡片
        NoticeCard *card = [[NoticeCard alloc] initWithFrame:CGRectMake(10, cellH, SCR_WIDTH-20, 100) data:noti];
        [self.contentView addSubview:card];
        
        //添加阴影，必须在card有superview之后才可以加上
        //[JKFunction addShadowToView:card];
        
        cellH += card.frame.size.height+20;
    }
    
    return [NSNumber numberWithFloat:cellH];
}


- (void)btnAction:(UIButton*)btn
{
    if(!btn) return;
    [DDCenter actionForLinkURL:(NSString*)btn.tagData];
}


@end
