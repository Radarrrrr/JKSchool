//
//  Constants.h
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//
#import "JKFunction.h"


//常用的宏设定
#define IPHONEX_OR_LATER   [JKFunction iPhoneXorLater]   //是否iPhoneX或者更高 
#define STATUS_BAR_HEIGHT  ((IPHONEX_OR_LATER) ? 44.0f : 20.0f)
#define VIEW_WIDTH         [UIScreen mainScreen].bounds.size.width //页面可显示区域的宽度
#define VIEW_HEIGHT        [UIScreen mainScreen].bounds.size.height - STATUS_BAR_HEIGHT - 49  //从导航条向下，tabbar向上的显示区域高度
#define VIEW_HEIGHT_TAB    VIEW_HEIGHT+49  //导航条向下的所有区域高度，用在没有tabbar的页面中

#define COLOR(x) [RDFunction colorFromHexString:x] //16进制颜色(html颜色值)字符串转为UIColor 如：@"#3300ff"

#define AT(x)           [JKFunction fixedPixel:x]           //把像素尺寸按设备不同等比例调整，基础尺寸为750x1334
#define IMAGE(str)      [UIImage imageNamed:str]            //快速创建一个图片对象

#define StatusCode(d)   [JKFunction statusCodeFromData:d]       //从返回数据中获取状态码, 返回值为 NSInteger 类型
#define NICEDATA(d)     [JKFunction checkStatusCodeOKForData:d] //检测返回的数据是否是合理数据


#define RequestUrlMake(action, parameter) [JKFunction assembleRequestUrl:action param:parameter] //目前只支持一个参数

//接口宏设定
#define API_PREFIX      @"http://testapi.cdhhrs.com" //接口地址

#define ACTION_ROTATES  @"/advertise/rotates"    //轮播广告



 



