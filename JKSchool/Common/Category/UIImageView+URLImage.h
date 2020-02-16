//
//  UIImageView+URLImage.h
//  RDIconsViewDemo
//
//  Created by Radar on 2020/2/2.
//  Copyright © 2020年 Radar. All rights reserved.
//  version 1.0

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImageView (URLImage)

@property (nonatomic, copy) NSString *url; //网络图片的url, or bundle image path ，or image name（虽然名字有点不太合适）

- (void)loadImage:(NSString *)url; //加载图片，根据是网络图片url, 还是bundle图片路径url，or image name(一般不用这个，但是特殊情况下使用也支持)

@end

