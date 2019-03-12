//
//  Constants.h
//  JKSchool
//
//  Created by radar on 2019/3/9.
//  Copyright © 2019 radar. All rights reserved.
//
#import "JKFunction.h"


//常用的宏设定
#define IMAGE(str)  [UIImage imageNamed:str]     //快速创建一个图片对象

#define RequestUrlMake(action, parameter) [JKFunction assembleRequestUrl:action param:parameter] //目前只支持一个参数

//接口宏设定
#define API_PREFIX      @"http://testapi.cdhhrs.com" //接口地址

#define ACTION_ROTATES  @"/advertise/rotates"    //轮播广告



 



