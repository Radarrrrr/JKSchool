//
//  DDURLImageView.h
//  DDDevLib
//
//  Created by Radar on 12-11-29.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
// 


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>



@class DDURLImageView;
@protocol DDURLImageViewDelegate <NSObject>
@optional
-(void)ddURLImageViewDidLoad:(DDURLImageView*)ddURLImageView image:(UIImage*)image;
-(void)ddURLImageViewDidTap:(DDURLImageView*)ddURLImageView atPoint:(CGPoint)atPoint image:(UIImage*)image;
@end


@interface DDURLImageView : UIImageView {

	UIActivityIndicatorView *_spinner;
	NSURLConnection    *connection;
	NSMutableData      *characterBuffer;
	BOOL               done;
	NSThread		   *_subThreed;
	NSString           *_url;


#pragma mark -
#pragma mark out use params	
	UIImage    *photo;		  //显示在nomal状态下的photo，主要用于显示的，可用在网络和本地两种状态下，如果网络状态，只读取这个图片
	NSString   *tagString;    //字符串型的tag，和UIButton互补，如果只需要使用NSIntager类型的tag，只需要使用UIButton类的tag，即可。
	BOOL        bUseUrlCache; //default is NO //是否使用本地存储图片，使用url做md5转化以后做图片名字，保存在docunment里
	BOOL        bRoundRect;   //default is NO //是否使用圆角图片
	BOOL		bShowSpinner; //default is NO //是否显示spinner
	
@private
	id _delegate;	
}

@property (assign) id<DDURLImageViewDelegate> delegate;

@property (nonatomic, retain) UIImage               *photo;
@property (nonatomic, retain) NSString				*tagString;
@property (nonatomic, retain) NSString              *_url;
@property (nonatomic, retain) NSURLConnection		*connection;
@property (nonatomic, retain) NSMutableData			*characterBuffer;
@property (nonatomic)         BOOL					bUseUrlCache;
@property (nonatomic)         BOOL					bRoundRect;
@property (nonatomic)         BOOL					bShowSpinner;
@property (nonatomic, retain) NSThread		        *_subThreed;


#pragma mark -
#pragma mark in use functions
-(void)startWait;
-(void)stopWait;
-(void)cancel;
-(void)fillPhoto;
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
-(void)tapActionAtPoint:(CGPoint)atPoint;



#pragma mark -
#pragma mark out use functions
-(void)setURLImageViewFrame:(CGRect)newframe; //改变frame大小的时候采用
-(void)startLoading:(NSString*)url;			  //通过URL读取图片的方式
-(void)updateLayer:(UIImage*)aphoto;		  //使用图片可以直接更新，不用读取了



@end
