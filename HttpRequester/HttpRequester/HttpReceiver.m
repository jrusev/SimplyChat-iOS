//
//  HttpReceiver.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//  Copyright (c) 2014 JR. All rights reserved.
//

#import "HttpReceiver.h"

@implementation HttpReceiver

- (void)connect {
    HttpRequester *requester = [[HttpRequester alloc] init];
    
    NSString *postUrl = @"http://localhost:1337/auth/token";
    NSString *postContent = [NSString stringWithFormat:@"&grant_type=%@&client_id=%@&client_secret=%@&username=%@&password=%@",@"password",@"mobileV1",@"abc123456",@"admin", @"admin"];
    NSString *getUrl = @"http://localhost:1337/api/users/profile";
    
    NSString *token = @"cbMlxxmFBbZ2p3YOuSfEfOeMYFppdEpQOUrDGJXW+jo=";
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", token] };
    [requester httpGetWithURL:getUrl headers:headers delegate:self];
    //[requester httpPostWithURL:postUrl content:postContent delegate:self];
    
    // Create a loop until we get the data back
    NSDate *futureTime = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:futureTime];
}

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

#pragma mark - HttpReceiverDelegate

-(void)receivedData:(NSData *)data {

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
