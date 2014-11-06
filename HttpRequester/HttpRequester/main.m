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

void makeGetRequest() {
    
    HttpRequester *requester = [[HttpRequester alloc] init];
    HttpReceiver *receiver = [[HttpReceiver alloc] init];
    
    NSString *url = @"http://localhost:1337/api/users";
    
    [requester httpGet:url headers:nil target:receiver];
    
    // Create a loop until we get the data back
    while (!receiver.data) {
        NSDate *futureTime = [NSDate dateWithTimeIntervalSinceNow:0.1];
        [[NSRunLoop currentRunLoop] runUntilDate:futureTime];
    }
    
    NSString* response = [[NSString alloc] initWithData:receiver.data encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@", response);
}

void makePostRequest() {
    HttpReceiver *receiver = [[HttpReceiver alloc] init];
    
    NSString *post = [NSString stringWithFormat:@"&grant_type=%@&client_id=%@&client_secret=%@&username=%@&password=%@",@"password",@"mobileV1",@"abc123456",@"admin", @"admin"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:1337/auth/token"]]];
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
    
    // Create a loop until we get the data back
    while (!receiver.data) {
        NSDate *futureTime = [NSDate dateWithTimeIntervalSinceNow:0.1];
        [[NSRunLoop currentRunLoop] runUntilDate:futureTime];
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        makeGetRequest();
        makePostRequest();
        

    }
    return 0;
}
