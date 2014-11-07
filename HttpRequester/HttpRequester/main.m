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

        HttpReceiver *receiver = [[HttpReceiver alloc] init];
        [receiver connect];
    
    }
    return 0;
}
