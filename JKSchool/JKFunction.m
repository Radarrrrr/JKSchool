//
//  JKFunction.m
//  JKSchool
//
//  Created by radar on 2019/3/11.
//  Copyright © 2019 radar. All rights reserved.
//

#import "JKFunction.h"

@implementation JKFunction

+ (NSString *)assembleRequestUrl:(NSString*)action param:(NSString*)param
{
    if(!STRVALID(action)) return nil;
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", API_PREFIX, action];
    
    if(STRVALID(param))
    {
        requestURL = [requestURL stringByAppendingFormat:@"/{%@}", param];
    }
    
    return requestURL;
}

+ (id)dataConveredFromBinary:(id)binaryData
{
    if(!binaryData) return nil;
    
    NSString *jsonString = [[NSString alloc] initWithData:binaryData encoding:NSUTF8StringEncoding];  
    id data = [RDFunction dataFromJsonString:jsonString];
    
    return data;
}

+ (BOOL)iPhoneXorLater
{
    if([UIScreen instancesRespondToSelector:@selector(currentMode)])
    {
        float w = [[UIScreen mainScreen] currentMode].size.width;
        float h = [[UIScreen mainScreen] currentMode].size.height;
        float k = h/w; //屏幕高宽比
        
        if(k > 2) 
        {
            return YES;
        }
    }
    
    return NO;
}

+ (float)fixedPixel:(float)pixel
{
    //把像素尺寸按设备不同等比例调整，基础尺寸为750x1334
    float w = [[UIScreen mainScreen] currentMode].size.width;
    float k = w/750.0; //当前设备与750基础尺寸的比例

    return pixel*k;
}

+ (NSInteger)statusCodeFromData:(NSDictionary*)data
{
    if(!DICTIONARYVALID(data)) return -1;
    NSNumber *code = [data objectForKey:@"status_code"];
    if(!code) return -1;
    return [code integerValue];
}

+ (BOOL)checkStatusCodeOKForData:(NSDictionary*)data
{
    NSInteger code = [JKFunction statusCodeFromData:data];
    if(code == 200) return YES;
    return NO;
}


@end
