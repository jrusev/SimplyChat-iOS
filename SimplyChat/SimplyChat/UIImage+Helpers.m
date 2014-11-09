//
//  UIImage+Helpers.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/10/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "UIImage+Helpers.h"

@implementation UIImage (Helpers)

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}

@end
