//
//  URLCache.h
//  FlickrPlug
//
//  Created by Jack on 3/12/09.
//  Copyright 2009 Redsafi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

static inline NSString *md5Encode( NSString *str ) {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *string = [NSString stringWithFormat:
						@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
						result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
						result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
						];
    return [string lowercaseString];
}


@interface URLCache : NSObject {
    
    
}

/*****************************************/
/** Get shared instance					 */
/*****************************************/
+ (URLCache *)sharedCacher;

/*****************************************/
/** Cache image from URL				 */
/*****************************************/
- (void) cacheUrlImage:(NSString *)url image:(UIImage*)image;

/*****************************************/
/** Delete cached image file			 */
/*****************************************/
- (void) deleteCacheUrlImage:(NSString *)url;

/*****************************************/
/** If cached, return the cached image   */
/*****************************************/
- (UIImage *) cachedUrlImage:(NSString*)url;


/*****************************************/
/** Cache image from local				 */
/*****************************************/
- (void) cacheLocalImage:(NSString *)filename image:(UIImage*)image;

/*****************************************/
/** Delete cached image file			 */
/*****************************************/
- (void) deleteCacheLocalImage:(NSString *)filename;

/*****************************************/
/** If cached, return the cached image   */
/*****************************************/
- (UIImage *) cachedLocalImage:(NSString*)filename;

@end 