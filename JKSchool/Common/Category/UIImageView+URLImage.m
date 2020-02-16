//
//  UIImageView+URLImage.m
//  RDIconsViewDemo
//
//  Created by Radar on 2020/2/2.
//  Copyright © 2020年 Radar. All rights reserved.
//

#import "UIImageView+URLImage.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>


@implementation UIImageView (URLImage)

static char urlKey;
-(void)setUrl:(NSString *)url
{
    objc_setAssociatedObject(self, &urlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)url
{
    return objc_getAssociatedObject(self, &urlKey);
}


- (void)loadImage:(NSString *)url
{
    if(!url || [url isEqualToString:@""]) return;
    self.url = url;
    
    NSRange range = [url rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.length == 0)
    {
        //一个斜杠都没有，是本地图片直接加载
        self.image = [UIImage imageNamed:url];
    }
    else 
    {
        //有斜杠，判断是否网络图片或bundle图片
        if([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])
        {
            //从catch中获取先
            UIImage *cachedImg = [self imageFromCache:url];
            if(!cachedImg)
            {
                //读取网络图片
                [self downLoadImage:url completion:^(UIImage *image) {
                    self.image = image;
                    [self cacheImage:image forUrl:url];
                }];
            }
            else
            {
                self.image = cachedImg;
            }
        }
        else //其余统统判定为bundle图片，加载不出来就认了
        {
            self.image = [UIImage imageWithContentsOfFile:url];
        }
    }
}

- (void)downLoadImage:(NSString*)url completion:(void(^)(UIImage* image))completion
{
    if(!url || [url isEqualToString:@""])
    {
        if(completion)
        {
            completion(nil);
        }
        return;
    }
    
    //把url做一下容错处理，去掉回车和换行符号
    NSString *clearURL = url;
    if(clearURL)
    {
        clearURL = [clearURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        clearURL = [clearURL stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        clearURL = [clearURL stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    //下载数据
    NSURL *downUrl = [NSURL URLWithString:clearURL];
    if(!downUrl)
    {
        if(completion)
        {
            completion(nil);
        }
        return;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:downUrl
                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                    
                    id data = nil;
                    
                    if(!error)
                    {
                        data = [NSData dataWithContentsOfURL:location];
                    }  
                    
                    //把data转化为图片
                    UIImage *image = nil;
                    if(data)
                    {
                        image = [UIImage imageWithData:data];
                    }
                    
                    //回上层
                    if(completion)
                    {
                        completion(image);
                    }
                    
                }] resume];
}



#pragma mark - 图片缓存处理相关
static inline NSString *md5Encode(NSString *str) 
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *string = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                        ];
    return [string lowercaseString];
}

- (void)cacheImage:(UIImage*)image forUrl:(NSString *)url;
{
    if(!url || [url isEqualToString:@""]) return;
    if(!image) return;
    
    NSString *name;
    NSData *imageData;
    if([url hasSuffix:@".png"] || [url hasSuffix:@".PNG"])
    {
        name = [NSString stringWithFormat:@"%@.png", md5Encode(url)];
        imageData = UIImagePNGRepresentation(image);
    }
    else
    {
        name = [NSString stringWithFormat:@"%@.jpg", md5Encode(url)];
        imageData = UIImageJPEGRepresentation(image, 1.0);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [cachesDirectory stringByAppendingPathComponent:name];
    [imageData writeToFile:fullPathToFile atomically:NO]; //新图强行覆盖旧图
}

- (UIImage *)imageFromCache:(NSString*)url
{
    if(!url || [url isEqualToString:@""]) return nil;
    
    NSString *name;
    if([url hasSuffix:@".png"] || [url hasSuffix:@".PNG"])
    {
        name = [NSString stringWithFormat:@"%@.png", md5Encode(url)];
    }
    else
    {
        name = [NSString stringWithFormat:@"%@.jpg", md5Encode(url)];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [cachesDirectory stringByAppendingPathComponent:name];
    
    if([fileManager fileExistsAtPath:fullPathToFile])
    {
        NSData *data = [NSData dataWithContentsOfFile:fullPathToFile];
        return [UIImage imageWithData:data];
    }
    return nil;
}




@end
