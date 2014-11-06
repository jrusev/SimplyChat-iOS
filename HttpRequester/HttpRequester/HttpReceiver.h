//
//  HttpReceiver.h
//  HttpRequester
//
//  Created by JR on 11/4/14.
//  Copyright (c) 2014 JR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequester.h"

@interface HttpReceiver : NSObject<HttpRequesterDelegate>

@property (nonatomic, strong) NSData *data;

@end
