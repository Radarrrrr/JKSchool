//
//  RDSlidePageControl.h
//  RDIconsViewDemo
//
//  Created by Radar on 2020/2/8.
//  Copyright © 2020年 Radar. All rights reserved.
//
// PS: 此类为线型滑动杆，暂且固定尺寸，以后可修改
//     接口通用，如果需要其他类型页码模块，设置成相同接口即可和RDIconsView配合

#import <UIKit/UIKit.h>

@interface RDSlidePageControl : UIView

@property (nonatomic, strong) UIColor *chuteColor;  //滑槽颜色 //default: RGB: (220,220,220)
@property (nonatomic, strong) UIColor *sliderColor; //滑块颜色 //default: RGB: (9,185,169)

- (void)bindingToHostScrollView:(UIScrollView *)scrollView; //把本模块绑定到宿主的scrollView上，监听滑动比例，跟随滚动

@end


