//
//  HttpRequester.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//
//

#import "HttpRequester.h"

@implementation HttpRequester

- (void)httpPostWithURL:(NSString *)url
                headers:(NSDictionary *)headers
                content:(NSString *)content
               callback:(void (^)(NSError *error, NSData *data))callback {
    
    NSData *postData = [content dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData]; // http://stackoverflow.com/a/405896
    [request setTimeoutInterval:60.0];    
    
    for (NSString* key in headers) {
        NSString* value = [headers objectForKey:key];
        [request setValue:value forHTTPHeaderField:key];
    }
    
    [self sendRequest:request callback:callback];    
}

- (void) httpGetWithURL:(NSString *)url headers:(NSDictionary *)headers callback:(void (^)(NSError *error, NSData *data))callback {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData]; // http://stackoverflow.com/a/405896
    [request setTimeoutInterval:60.0];
    
    for (NSString* key in headers) {
        NSString* value = [headers objectForKey:key];
        [request setValue:value forHTTPHeaderField:key];
    }
    
    [self sendRequest:request callback:callback];
}

- (void)sendRequest:(NSURLRequest*)request callback:(void (^)(NSError *error, NSData *data))callback {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               //NSInteger code = [(NSHTTPURLResponse*)response statusCode];
                               //NSLog(@"[HttpRequester] Status code: %ld", code);
                               callback(error, data);
                           }];
}

@end
