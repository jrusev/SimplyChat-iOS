//
//  Notifier.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "Notifier.h"

@implementation Notifier

+(void)showAlert:(NSString *)title message:(NSString *)message andBtn:(NSString *)button{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:button otherButtonTitles:nil, nil]
     show];
}

@end
