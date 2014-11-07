//
//  HttpRequester.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//
//

#import "HttpRequester.h"

@implementation HttpRequester

- (void)httpPostWithURL:(NSString *)url content:(NSString *)content delegate:(id<HttpRequesterDelegate>)receiver {
    
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
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (error) {
                                   [receiver failedWithError:error];
                               } else {
                                   [receiver receivedData:data];
                               }
                           }];
    
}

- (void) httpGetWithURL:(NSString *)url headers:(NSDictionary *)headers delegate:(id<HttpRequesterDelegate>)receiver {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData]; // http://stackoverflow.com/a/405896
    [request setTimeoutInterval:60.0];
    
    for (NSString* key in headers) {
        NSString* value = [headers objectForKey:key];
        [request setValue:value forHTTPHeaderField:key];
    }
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               if (error) {
                                   [receiver failedWithError:error];
                               } else {
                                   [receiver receivedData:data];
                               }
                           }];
}

@end
