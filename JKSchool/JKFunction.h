//
//  JKFunction.h
//  JKSchool
//
//  Created by radar on 2019/3/11.
//  Copyright © 2019 radar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKFunction : NSObject

+ (NSString *)assembleRequestUrl:(NSString*)action param:(NSString*)param; //封装数据请求url，目前只处理一个参数的情况

+ (id)dataConveredFromBinary:(id)binaryData; //把二进制数据，转化成数组/字典格式数据 PS：前提是binaryData一定是二进制格式，并且一定是能转成json格式的二进制w数据，里边不做校验了

+ (BOOL)iPhoneXorLater; //是否iPhoneX以后的机型

@end

