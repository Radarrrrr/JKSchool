//
//  LeaveManageCell.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "LeaveManageCell.h"

@interface LeaveManageCell ()

@property (nonatomic, strong) UILabel *tLabel;

@end


@implementation LeaveManageCell

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
    _tLabel.text = @"请假管理";
    [self.contentView addSubview:_tLabel];
    
    //add moreBtn
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(SCR_WIDTH-40-10, 0, 40, 40);
    moreBtn.backgroundColor = COLOR_CLEAR;
    moreBtn.titleLabel.font = FONT(12.0);
    [moreBtn setTitle:@"详情 >" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_TEXT_C forState:UIControlStateNormal];
    moreBtn.tagData = @"leavemanage://";
    [moreBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    
    //add 三个入口按钮
    float btnW = (float)(SCR_WIDTH-20-8)/3.0;
    
    UIButton *leaveBtn = [UIButton buttonWithColor:COLOR(@"#FFFBE7") selColor:RGBS(230)];
    leaveBtn.frame = CGRectMake(10, POS_D(_tLabel, 10), btnW, 70);
    leaveBtn.titleLabel.font = FONT(14.0);
    [leaveBtn setTitle:@"请假" forState:UIControlStateNormal];
    [leaveBtn setTitleColor:COLOR_TEXT_B forState:UIControlStateNormal];
    leaveBtn.tagData = @"leavemanage://type=leave";
    [leaveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [RDFunction addRadiusToView:leaveBtn radius:5];
    [self.contentView addSubview:leaveBtn];
    
    UIButton *supplyBtn = [UIButton buttonWithColor:COLOR(@"#FFF0F0") selColor:RGBS(230)];
    supplyBtn.frame = CGRectMake(POS_R(leaveBtn, 4), CGRectGetMinY(leaveBtn.frame), btnW, 70);
    supplyBtn.titleLabel.font = FONT(14.0);
    [supplyBtn setTitle:@"补充信息" forState:UIControlStateNormal];
    [supplyBtn setTitleColor:COLOR_TEXT_B forState:UIControlStateNormal];
    supplyBtn.tagData = @"leavemanage://type=supply";
    [supplyBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [RDFunction addRadiusToView:supplyBtn radius:5];
    [self.contentView addSubview:supplyBtn];
    
    UIButton *interruptBtn = [UIButton buttonWithColor:COLOR(@"#ECF8FF") selColor:RGBS(230)];
    interruptBtn.frame = CGRectMake(POS_R(supplyBtn, 4), CGRectGetMinY(leaveBtn.frame), btnW, 70);
    interruptBtn.titleLabel.font = FONT(14.0);
    [interruptBtn setTitle:@"销假" forState:UIControlStateNormal];
    [interruptBtn setTitleColor:COLOR_TEXT_B forState:UIControlStateNormal];
    interruptBtn.tagData = @"leavemanage://type=interrupt";
    [interruptBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [RDFunction addRadiusToView:interruptBtn radius:5];
    [self.contentView addSubview:interruptBtn];
 
}
- (NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    
    return [NSNumber numberWithFloat:120];
}

- (void)btnAction:(UIButton*)btn
{
    if(!btn) return;
    [DDCenter actionForLinkURL:(NSString*)btn.tagData];
}


@end
