//
//  SampleCell.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "HornCell.h"
#import "CMSHornView.h"

@interface HornCell ()

@property (nonatomic, strong) CMSHornView *hornView;

@end


@implementation HornCell

- (void)setCellStyle
{
    //设定cell的样式，所有的组件都放在 self.contentView 上面，做成全局变量，用以支持 setCellData 里边来修改组件的数值
    
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //add hornView
    self.hornView = [[CMSHornView alloc] initWithFrame:CGRectMake(10, 8, SCR_WIDTH-20, 44)];
    _hornView.backgroundColor = RGBS(250);//[UIColor whiteColor];
    [self.contentView addSubview:_hornView];
    
    [RDFunction addRadiusToView:_hornView radius:6];
    //[JKFunction addShadowToView:_hornView];
    
}

- (NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    _hornView.hornDatas = data;
    
    return [NSNumber numberWithFloat:60];
}


@end
