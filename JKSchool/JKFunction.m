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

@end
