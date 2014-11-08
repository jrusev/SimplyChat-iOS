//
//  User.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "User.h"

#define USER_USERNAME @"username"
#define USER_FIRSTNAME @"firstName"
#define USER_LASTNAME @"lastName"

@implementation User

// Designated Initializer
-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self){
        self.username = data[USER_USERNAME];
        self.firstName = data[USER_FIRSTNAME];
        self.lastName = data[USER_LASTNAME];
    }
    return self;
}

-(id)init
{
    self = [self initWithData:nil];
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
