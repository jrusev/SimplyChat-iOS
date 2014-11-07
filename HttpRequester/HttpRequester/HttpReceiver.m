//
//  HttpReceiver.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//  Copyright (c) 2014 JR. All rights reserved.
//

#import "HttpReceiver.h"

#define URL_AUTH_TOKEN @"http://localhost:1337/auth/token"
#define URL_USERS_PROFILE @"http://localhost:1337/api/users/profile"

@interface HttpReceiver()

@property (nonatomic, strong) HttpRequester *requester;

@end

@implementation HttpReceiver

- (HttpRequester *)requester {
    if (!_requester) {
        _requester = [[HttpRequester alloc] init];
    }
    return _requester;
}

- (void)connect {
    
    NSString *postContent = [NSString stringWithFormat:@"&grant_type=%@&client_id=%@&client_secret=%@&username=%@&password=%@",@"password",@"mobileV1",@"abc123456",@"admin", @"admin"];
    
    [self.requester httpPostWithURL:URL_AUTH_TOKEN content:postContent callback:^(NSError *error, NSData *data) {
        if (error) {
            [self failedWithError:error];
        } else {
            [self receivedToken:data];
        }
    }];
    
    // Create a loop until we get the data back
    NSDate *futureTime = [NSDate dateWithTimeIntervalSinceNow:1.0];
    [[NSRunLoop currentRunLoop] runUntilDate:futureTime];
}

#pragma mark - private methods

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

-(void)receivedToken:(NSData *)data {
    
    NSDictionary *jsonObj = [self getJson:data];
    NSString *token = jsonObj[@"access_token"];
    NSLog(@"access_token: %@", token);
   
   
    //NSString *token = @"cbMlxxmFBbZ2p3YOuSfEfOeMYFppdEpQOUrDGJXW+jo=";
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", token] };
    
    [self.requester httpGetWithURL:URL_USERS_PROFILE headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            [self failedWithError:error];
        } else {
            [self receivedData:data];
        }
    }];
}

- (void)printData:(NSData *)data {
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@", dataString);
}

#pragma mark - HttpReceiverDelegate

-(void)receivedData:(NSData *)data {
    
    NSDictionary *jsonObj = [self getJson:data];
    NSLog(@"JSON received: %@", jsonObj);
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
