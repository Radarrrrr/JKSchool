//
//  IconsCell.m
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//

#import "IconsCell.h"
#import "RDIconsView.h"

@interface IconsCell ()

@property (nonatomic, strong) RDIconsView *iconsView;

@end


@implementation IconsCell

- (void)setCellStyle
{
    //设定cell的样式，所有的组件都放在 self.contentView 上面，做成全局变量，用以支持 setCellData 里边来修改组件的数值
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //add _iconsView
    self.iconsView = [[RDIconsView alloc] init];
    [self.contentView addSubview:_iconsView];
    [_iconsView handleIconPressed:^(NSDictionary *icon) {
        [self handleIconPress:icon];
    }];
    
}

- (NSNumber*)setCellData:(id)data atIndexPath:(NSIndexPath*)indexPath
{
    //根据data设定cell上组件的属性，并返回计算以后的cell高度, 用number类型装进去，[重要]cell高度必须要做计算并返回，如果返回nil就使用默认的44高度了
    //icons: [{"icon_img":"xxx", "icon_name":"xxx", "link_url":"xxxx"},...]    
    if(!data || !ARRAYVALID(data)) return nil;
    
    [_iconsView setIcons:(NSArray*)data];
    
    return [NSNumber numberWithFloat:_iconsView.frame.size.height];
}

- (void)handleIconPress:(NSDictionary *)icon
{
    if(!DICTIONARYVALID(icon)) return;
    
    NSString *linkURL = [icon objectForKey:@"link_url"];
    [DDCenter actionForLinkURL:linkURL];
}

@end
