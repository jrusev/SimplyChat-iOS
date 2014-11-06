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

-(void)receivedData:(NSData *)data {
    self.data = data;
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@", response);
    
    NSData *returnedData = data;
    
    // probably check here that returnedData isn't nil; attempting
    // NSJSONSerialization with nil data raises an exception, and who
    // knows how your third-party library intends to react?
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:returnedData
                     options:0
                     error:&error];
        
        if(error) { /* JSON was malformed, act appropriately here */ }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            NSLog(@"JSON object: %@", results);
            NSLog(@"access_token: %@", results[@"access_token"]);
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    }
    else
    {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }
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
