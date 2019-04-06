//
//  URLCache.m
//  FlickrPlug
//
//  Created by Jack on 3/12/09.
//  Copyright 2009 Redsafi. All rights reserved.
//

#import "URLCache.h"

static URLCache *_sharedCacher;

@implementation URLCache


- (id)init {
	if((self = [super init]))
	{
		
	}
	return self;
}

+ (URLCache *)sharedCacher{
	if (!_sharedCacher) {
		_sharedCacher = [[URLCache alloc] init];
	}
	return _sharedCacher;
}

- (void) cacheUrlImage:(NSString *)url image:(UIImage*)image{
    if(url == nil) return;
    if(image == nil) return;
    
    NSString * name;
    NSData* imageData;
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
    
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* cachesDirectory = [paths objectAtIndex:0];
	NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:name];
	[imageData writeToFile:fullPathToFile atomically:NO];
}

- (void) deleteCacheUrlImage:(NSString *)url{
    if(url == nil) return;
    
	NSString * name;
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
	NSError* error;
	NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:name];
	
	if ([fileManager fileExistsAtPath:fullPathToFile] == YES)
	{
		[fileManager removeItemAtPath:fullPathToFile error:&error];
	}
}

- (UIImage *) cachedUrlImage:(NSString*)url{
	if(url == nil) return nil;
    
    NSString * name;
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
	NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:name];
	
	if ([fileManager fileExistsAtPath:fullPathToFile] == YES){
		
		NSData * data = [NSData dataWithContentsOfFile:fullPathToFile];
		return [UIImage imageWithData:data];
	}
	return nil;
}


/*****************************************/
/** Cache image from local				 */
/*****************************************/
- (void) cacheLocalImage:(NSString *)filename image:(UIImage*)image{
	NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* cachesDirectory = [paths objectAtIndex:0];
	NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:filename];
	[imageData writeToFile:fullPathToFile atomically:NO];
}

/*****************************************/
/** Delete cached image file			 */
/*****************************************/
- (void) deleteCacheLocalImage:(NSString *)filename{
		
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	NSError* error;
	NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:filename];
	
	if ([fileManager fileExistsAtPath:fullPathToFile] == YES)
	{
		[fileManager removeItemAtPath:fullPathToFile error:&error];
	}
}

/*****************************************/
/** If cached, return the cached image   */
/*****************************************/
- (UIImage *) cachedLocalImage:(NSString*)filename{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	NSString* fullPathToFile = [cachesDirectory stringByAppendingPathComponent:filename];
	
	if ([fileManager fileExistsAtPath:fullPathToFile] == YES){
		
		NSData * data = [NSData dataWithContentsOfFile:fullPathToFile];
		return [UIImage imageWithData:data];
	}
	return nil;
	
}


- (void)dealloc {
   	[_sharedCacher release];
    [super dealloc];
}

@end 