//
//  RDIconsView.h
//  RDIconsViewDemo
//
//  Created by Radar on 2020/2/1.
//  Copyright © 2020年 Radar. All rights reserved.
//
//PS: 第一版先只支持固定尺寸, 只支持最多两行icon，且每行最多5个

#import <UIKit/UIKit.h>

@interface RDIconsView : UIView

- (void)setIcons:(NSArray *)icons; //icons: [{"icon_img":"xxx", "icon_name":"xxx", "link_url":"xxxx"},...]  //PS: icon_img字段如果带http://或者https://则自动读取网络图片，否则当作本地图片处理

- (void)handleIconPressed:(void (^)(NSDictionary *icon))action; //处理icon按下事件

@end

