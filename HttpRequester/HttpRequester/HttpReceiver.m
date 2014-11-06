//
//  HttpReceiver.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//  Copyright (c) 2014 JR. All rights reserved.
//

#import "HttpReceiver.h"

@implementation HttpReceiver

#pragma mark - HttpReceiverDelegate

- (NSDictionary *)getJson:(NSData *)data {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error || ![object isKindOfClass:[NSDictionary class]]) {
        NSLog(@"There was a problem deserializing from JSON");
        return nil;
    }

    NSDictionary *results = object;
    return results;
}

-(void)receivedData:(NSData *)data {
    self.data = data;
//    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Response received: %@", response);
    
    NSDictionary *jsonObj = [self getJson:data];
    NSLog(@"JSON received: %@", jsonObj);
    NSLog(@"access_token: %@", jsonObj[@"access_token"]);
}

- (void)failedWithError:(NSError *)error {
    NSLog(@"Connection error: %@", error);
}

// http://stackoverflow.com/a/405896
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    // return nil if no cached response should be stored for the connection.
    return nil;
}

@end
