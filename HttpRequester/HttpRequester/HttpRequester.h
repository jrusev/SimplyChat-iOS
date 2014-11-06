//
//  HttpRequester.h
//  HttpRequester
//
//  Created by JR on 11/4/14.
//
//

#import <Foundation/Foundation.h>

@protocol HttpRequesterDelegate<NSObject>

- (void)receivedData:(NSData *)data;
- (void)failedWithError:(NSError *)error;

@optional

// http://stackoverflow.com/a/405896
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse;

@end

@interface HttpRequester : NSObject

- (void)httpPostWithURL:(NSString *)urlString content:(NSString *)contentString delegate:(id<HttpRequesterDelegate>)receiver;
- (void) httpGetWithURL:(NSString *)urlString delegate:(id<HttpRequesterDelegate>)receiver;

@end
