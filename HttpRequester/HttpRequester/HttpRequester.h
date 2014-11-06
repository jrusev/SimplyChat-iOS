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

@end

@interface HttpRequester : NSObject

-(void)httpPost:(NSString*)URLString headers:(NSDictionary*)headers data:(NSData*)data target:(id<HttpRequesterDelegate>)target;
-(void)httpGet:(NSString*)URLString headers:(NSDictionary*)headers target:(id<HttpRequesterDelegate>)target;
-(void)httpPut:(NSString *)URLString headers:(NSDictionary *)headers data:(NSData *)data target:(id<HttpRequesterDelegate>)target;
-(void)httpDelete:(NSString *)URLString headers:(NSDictionary *)headers target:(id<HttpRequesterDelegate>)target;

@end
