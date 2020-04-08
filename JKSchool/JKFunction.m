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

+ (void)makeupShadowOnView:(UIView*)hostView
{
    //更新阴影状态
    CALayer *layer = hostView.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
    layer.shadowPath = path.CGPath;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeZero;
    layer.shadowOpacity = 0.2;
    layer.shadowRadius = 3;
}

+ (void)addShadowToView:(UIView*)hostView
{
    if(!hostView) return;
    if(![hostView superview]) return;
    
    CGRect hrect = hostView.frame;
    
    float x = hrect.origin.x;
    float y = hrect.origin.y;
    float w = hrect.size.width;
    float h = hrect.size.height;
    
    //shadow 位置：上1，左右2，下3
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(x+1, y+2, w-2, h-2)];
    shadow.backgroundColor = [UIColor clearColor];
    shadow.userInteractionEnabled = NO;
    [JKFunction makeupShadowOnView:shadow];
    
    //放在host下面
    [hostView.superview insertSubview:shadow belowSubview:hostView];
    
}

+ (float)downPosReferTo:(UIView*)view offset:(float)offset //关联一个view的边缘，向下
{
    if(!view) return 0.0;
    return CGRectGetMaxY(view.frame)+offset;
}
+ (float)upPosReferTo:(UIView*)view offset:(float)offset //关联一个view的边缘，向上
{
    if(!view) return 0.0;
    return CGRectGetMinY(view.frame)-offset;
}
+ (float)leftPosReferTo:(UIView*)view offset:(float)offset //关联一个view的边缘，向左
{
    if(!view) return 0.0;
    return CGRectGetMinX(view.frame)-offset;
}
+ (float)rightPosReferTo:(UIView*)view offset:(float)offset //关联一个view的边缘，向右
{
    if(!view) return 0.0;
    return CGRectGetMaxX(view.frame)+offset;
}


+ (void)modifyFrameFor:(UIView *)view toX:(NSString *)x toY:(NSString *)y toW:(NSString *)w toH:(NSString*)h
{
    //修改一个view及其子类的frame，用于多次更改位置或大小，又不是每次所有属性全改的情况
    //参数为用float类型的数据做成NSString类型输入，如果不需要改，就直接输入nil
    if(!view) return;
    if(!x && !y && !w && !h) return;
    
    CGRect nframe = view.frame;
    if(x && ![x isEqualToString:@""])
    {
        nframe.origin.x = [x floatValue];
    }
    if(y && ![y isEqualToString:@""])
    {
        nframe.origin.y = [y floatValue];
    }
    if(w && ![w isEqualToString:@""])
    {
        nframe.size.width = [w floatValue];
    }
    if(h && ![h isEqualToString:@""])
    {
        nframe.size.height = [h floatValue];
    }
   
    view.frame = nframe;
}


+ (float)getHeightForString:(NSString *)string font:(UIFont *)font width:(float)width
{    
    if(!string || [string compare:@""] == NSOrderedSame) return 0.0;
    
    //段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *useString = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    
    CGSize size =  [useString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    //NSLog(@" size =  %@", NSStringFromCGSize(size));
    
    //计算出来的数据是小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1；
    CGFloat height = ceil(size.height) + 1;
    
    return height;
}




@end
