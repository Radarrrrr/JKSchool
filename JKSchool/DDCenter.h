//
//  DDCenter.h
//  TestNCEDeom
//
//  Created by Radar on 2017/3/16.
//  Copyright © 2017年 Radar. All rights reserved.
//

/* 支持的linkURL字典：

 home://                            //回到首页
 http://                            //http和https都直接开启web页面显示
 https://
 
 topic://id=x                       //跳转到专题页
 login://
 
 studentdoc://               //学生档案模块
 leavemanage://                            //请假管理模块
     leavemanage://type=leave              //请假管理-请假
     leavemanage://type=supply             //请假管理-补充信息
     leavemanage://type=interrupt          //请假管理-销假
 healthdata://               //健康数据模块
 schooldesc://               //学校简介模块
 teachermanage://            //老师管理
 studentmanage://            //学生管理
 alarmmsg://                 //预警信息      
 checking://                 //晨午检
 schedule://                 //课程表模块
 notice://                          //活动通知模块（全部）
    notice://id=xxx                 //具体通知页面
 
 
 
 //以下几个暂时保留以后可能用到
 qrscaner://                        //二维码扫描器
 plaintext://text=xxxx              //进入空白文字页面，用于二维码扫描以后直接显示二维码中的内容

*/
 
 
 
#import <Foundation/Foundation.h>

@interface DDCenter : NSObject

+ (void)actionForLinkURL:(NSString*)linkURL; //中央控制器跳转字典接口，使用字典触发

@end
