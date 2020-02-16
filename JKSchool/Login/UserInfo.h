//
//  UserInfo.h
//  JKSchool
//
//  Created by Radar on 2020/2/15.
//  Copyright © 2020年 radar. All rights reserved.
//
//当前登录用户的信息

#import <Foundation/Foundation.h>

//用户类
@interface HHUser : NSObject

@property (nonatomic, copy) NSString *uid;  //用户id
@property (nonatomic, copy) NSString *name; //用户名
@property (nonatomic, copy) NSString *type; //用户身份类别 -> PARENTS，TEACHER，or more

@end


//用户信息
@interface UserInfo : NSObject

@property (nonatomic, strong) HHUser *curUser; //当前登陆的用户信息 //存在userdefalut里，只保存当前登陆的用户信息，切换身份覆盖前面的

+ (instancetype)sharedInfo;

- (void)saveUser:(HHUser *)user; //保存userInfo信息到userdefault里，并更新全局变量curUser

@end


