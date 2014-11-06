//
//  HttpRequester.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//
//

#import "HttpRequester.h"

@implementation HttpRequester

-(void)httpPost:(NSString*)URLString headers:(NSDictionary*)headers data:(NSData*)data target:(id<HttpRequesterDelegate>)target{
    NSMutableURLRequest *request = [self buildRequestWithURL:URLString headers:headers data:data andType:@"POST"];
    [self sendRequest:request target:target andType:@"POST"];
}

-(void)httpGet:(NSString*)URLString
          headers:(NSDictionary*)headers
       target:(id<HttpRequesterDelegate>)target{
    NSMutableURLRequest *request = [self buildRequestWithURL:URLString headers:headers data:nil andType:@"GET"];
    [self sendRequest:request target:target andType:@"GET"];
}


-(void)httpPut:(NSString *)URLString headers:(NSDictionary *)headers data:(NSData *)data target:(id<HttpRequesterDelegate>)target{
    NSMutableURLRequest *request = [self buildRequestWithURL:URLString headers:headers data:data andType:@"PUT"];
    [self sendRequest:request target:target andType:@"PUT"];
}

-(void)httpDelete:(NSString *)URLString headers:(NSDictionary *)headers target:(id<HttpRequesterDelegate>)target{
    NSMutableURLRequest *request = [self buildRequestWithURL:URLString headers:headers data:nil andType:@"DELETE"];
    [self sendRequest:request target:target andType:@"DELETE"];
}

-(void)sendRequest:(NSMutableURLRequest*)request target:(id<HttpRequesterDelegate>)target andType:(NSString*)requestType{
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (error) {
                                   [target failedWithError:error];
                               } else {
                                   [target receivedData:data];
                               }
                           }];
}


-(NSMutableURLRequest*)buildRequestWithURL:(NSString *)URLString
                                   headers:(NSDictionary *)headers
                                      data:(NSData *)data
                                   andType:(NSString*)requestType{
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    [request setHTTPMethod:requestType];
    for (NSString* key in headers) {
        NSString* value = [headers objectForKey:key];
        [request setValue:value forHTTPHeaderField:key];
    }
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (data != nil) {
        [request setHTTPBody:data];
    }
    
    return request;
}

@end
