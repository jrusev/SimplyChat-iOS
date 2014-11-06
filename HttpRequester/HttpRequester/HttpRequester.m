//
//  HttpRequester.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//
//

#import "HttpRequester.h"

@implementation HttpRequester

- (void)httpPostWithURL:(NSString *)urlString content:(NSString *)contentString delegate:(id<HttpRequesterDelegate>)receiver {
    
    NSData *postData = [contentString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
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

- (void) httpGetWithURL:(NSString *)urlString delegate:(id<HttpRequesterDelegate>)receiver {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
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

@end
