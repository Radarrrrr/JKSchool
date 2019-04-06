//
//  DDURLImageView.m
//  DDDevLib
//
//  Created by Radar on 12-11-29.
//  Copyright (c) 2012年 www.dangdang.com. All rights reserved.
//


#import "DDURLImageView.h"
#import "URLCache.h"

#define spinner_size   25.0


@implementation DDURLImageView
@synthesize delegate=_delegate;
@synthesize photo;
@synthesize _url;
@synthesize characterBuffer;
@synthesize connection;
@synthesize bUseUrlCache;
@synthesize bRoundRect;
@synthesize bShowSpinner;
@synthesize _subThreed;
@synthesize tagString;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		
		self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
		
		//spinner
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_spinner.frame = CGRectMake((frame.size.width-spinner_size)/2, (frame.size.height-spinner_size)/2, spinner_size, spinner_size);
		_spinner.hidesWhenStopped = YES;
        _spinner.hidden = YES;
		[_spinner stopAnimating];
		[self addSubview:_spinner];
		
		self._subThreed = nil;
		self.bUseUrlCache = NO;
		self.bRoundRect = NO;
		self.bShowSpinner = NO;
		
    }
    return self;
}


- (void)dealloc {
	
	[self cancel];
	
	[_subThreed release];
	[_spinner release];
	[photo release];
	[tagString release];
	[characterBuffer release];
	[_url release];
	
    [super dealloc];
}




#pragma mark -
#pragma mark in use functions
-(void)startWait
{
	if(!bShowSpinner) return;
	
	_spinner.hidden = NO;
	[_spinner startAnimating];
}
-(void)stopWait
{
	if(!bShowSpinner) return;
	
	[_spinner stopAnimating];
	_spinner.hidden = YES;
}
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
	
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();

	return newImage;
}
-(void)cancel
{
	if(self.connection)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[self.connection cancel];
		self.connection = nil;
	}
	
	if(self._subThreed)
	{
		[self._subThreed cancel];
		self._subThreed = nil;
	}
	
	[self stopWait];
}
-(void)fillPhoto
{
	if(self.photo)
	{
		[self updateLayer:self.photo];
		[self stopWait];
		
		//catch
		if(self.bUseUrlCache)
		{
			[[URLCache sharedCacher] cacheUrlImage:self._url image:self.photo];
		}
		
		if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(ddURLImageViewDidLoad:image:)])
		{
			[self.delegate ddURLImageViewDidLoad:self image:self.photo];
		}
	}
}
-(void)tapActionAtPoint:(CGPoint)atPoint
{
	if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(ddURLImageViewDidTap:atPoint:image:)])
	{
		[self.delegate ddURLImageViewDidTap:self atPoint:atPoint image:self.photo];
	}
}



#pragma mark -
#pragma mark touches functions
- (void) touchesCanceled 
{
}
- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
}
- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event 
{
}
- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event 
{
	NSSet *allTouches = [event allTouches];
	
    switch ([allTouches count]) {
        case 1: 
		{
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			CGPoint tapPoint = [touch locationInView:self];
			
            switch (touch.tapCount) 
			{
                case 1: 
				{					
					[self tapActionAtPoint:tapPoint];
				}
					break;
				default:
					break;
            }
        }
			break;
		default:
			break;
	}
}




#pragma mark -
#pragma mark out use functions
- (void)setURLImageViewFrame:(CGRect)newframe
{
	self.frame = newframe;
	_spinner.frame = CGRectMake((self.frame.size.width-spinner_size)/2, (self.frame.size.height-spinner_size)/2, spinner_size, spinner_size);
}
-(void)startLoading:(NSString*) url
{
	[self cancel];
    
    //把url做一下容错处理，去掉回车和换行符号
    NSString *useURL = url;
    if(useURL)
    {
        useURL = [useURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        useURL = [useURL stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        useURL = [useURL stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
	self._url = useURL;
	
	if(!self._url)
	{
		[self updateLayer:nil];
		return;
	}
	
	//check catch 检查是否本地有图片缓存
	if(self.bUseUrlCache)
	{
		UIImage *cacheImage = [[URLCache sharedCacher] cachedUrlImage:self._url];
		if(cacheImage)
		{
			[self updateLayer:cacheImage];
			
			if(self.delegate &&[(NSObject*)self.delegate respondsToSelector:@selector(ddURLImageViewDidLoad:image:)])
			{
				[self.delegate ddURLImageViewDidLoad:self image:self.photo];
			}
			
			return;
		}
	}
	
	
	//读取网络图片
	[self startWait];
	[NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:self._url];

}
-(void)updateLayer:(UIImage*)aphoto
{    
    if(self.photo != aphoto)
    {
        self.photo = aphoto;
    }
    
	if(self.bRoundRect)
	{
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
	}
	
    self.alpha = 0.0;
	self.image = self.photo;
    
    [UIView beginAnimations:@"show_image" context:nil];
	[UIView setAnimationDuration:0.3];
	
	self.alpha = 1.0;
	
	[UIView commitAnimations];
    
}






#pragma mark -
#pragma mark private functions for connection
- (void)httpConnectStart 
{
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
- (void)httpConnectEnd 
{
    NSAssert2([NSThread isMainThread], @"%s at line %d called on secondary thread", __FUNCTION__, __LINE__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)downloadImage:(NSString*)url
{
	self._subThreed = [NSThread currentThread];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.characterBuffer = [NSMutableData data];
	done = NO;
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	
	self.connection = [[[NSURLConnection alloc] initWithRequest:theRequest delegate:self] autorelease];
	[self performSelectorOnMainThread:@selector(httpConnectStart) withObject:nil waitUntilDone:NO];
    if (self.connection != nil) 
	{
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!done);
    }
	
	self.photo = [UIImage imageWithData:characterBuffer];
	
	[self performSelectorOnMainThread:@selector(fillPhoto) withObject:nil waitUntilDone:NO];
	
    // Release resources used only in this thread.
    self.connection = nil;
	
	[pool release];
	self._subThreed = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    done = YES;
	[self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
	[characterBuffer setLength:0];
	
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
	[characterBuffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    [self performSelectorOnMainThread:@selector(httpConnectEnd) withObject:nil waitUntilDone:NO];
    done = YES; 
}



@end
