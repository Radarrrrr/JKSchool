//
//  JKFunction.h
//  JKSchool
//
//  Created by radar on 2019/3/11.
//  Copyright © 2019 radar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKFunction : NSObject

+ (NSString *)assembleRequestUrl:(NSString*)action param:(NSString*)param; //封装数据请求url，目前只处理一个参数的情况

+ (id)dataConveredFromBinary:(id)binaryData; //把二进制数据，转化成数组/字典格式数据 PS：前提是binaryData一定是二进制格式，并且一定是能转成json格式的二进制w数据，里边不做校验了

+ (BOOL)iPhoneXorLater; //是否iPhoneX以后的机型

+ (float)fixedPixel:(float)pixel; //把像素尺寸按设备不同等比例调整，基础尺寸为750x1334

+ (NSInteger)statusCodeFromData:(NSDictionary*)data; //从返回数据中获取状态码
+ (BOOL)checkStatusCodeOKForData:(NSDictionary*)data;//检查是否数据是合格的好数据，即是否status code为200

+ (void)makeupShadowOnView:(UIView*)hostView;   //给一个view添加阴影, PS: hostview必须是clear颜色
+ (void)addShadowToView:(UIView*)hostView;      //在一个view的下面添加阴影背景，PS：hostview必须先有superview

+ (float)downPosReferTo:(UIView*)view offset:(float)offset; //关联一个view的边缘，向下
+ (float)upPosReferTo:(UIView*)view offset:(float)offset; //关联一个view的边缘，向上
+ (float)leftPosReferTo:(UIView*)view offset:(float)offset; //关联一个view的边缘，向左
+ (float)rightPosReferTo:(UIView*)view offset:(float)offset; //关联一个view的边缘，向右

//修改一个view及其子类的frame，用于多次更改位置或大小，又不是每次所有属性全改的情况
//参数为用float类型的数据做成NSString类型输入，如果不需要改，就直接输入nil，配合STR_F(x)宏输入参数，更便捷
+ (void)modifyFrameFor:(UIView *)view toX:(NSString *)x toY:(NSString *)y toW:(NSString *)w toH:(NSString*)h;
    


//根据字符串的字体和显示宽度，计算总体要显示的高度
+ (float)getHeightForString:(NSString *)string font:(UIFont *)font width:(float)width;
    
@end

