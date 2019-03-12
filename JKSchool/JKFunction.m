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

@end
