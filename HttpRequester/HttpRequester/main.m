//
//  main.m
//  HttpRequester
//
//  Created by JR on 11/4/14.
//  Copyright (c) 2014 JR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequester.h"
#import "HttpReceiver.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        HttpRequester *requester = [[HttpRequester alloc] init];
        HttpReceiver *receiver = [[HttpReceiver alloc] init];
        
        NSString *postUrl = @"http://localhost:1337/auth/token";
        NSString *postContent = [NSString stringWithFormat:@"&grant_type=%@&client_id=%@&client_secret=%@&username=%@&password=%@",@"password",@"mobileV1",@"abc123456",@"admin", @"admin"];
        NSString *getUrl = @"http://localhost:1337/api/users";
        
        [requester httpGetWithURL:getUrl delegate:receiver];
        [requester httpPostWithURL:postUrl content:postContent delegate:receiver];
      
        // Create a loop until we get the data back
        NSDate *futureTime = [NSDate dateWithTimeIntervalSinceNow:1.0];
        [[NSRunLoop currentRunLoop] runUntilDate:futureTime];

    }
    return 0;
}
