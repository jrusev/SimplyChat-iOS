//
//  Message.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "Message.h"

#define MESSAGE_TITLE @"title"
#define MESSAGE_CONTENT @"content"
#define MESSAGE_DATE @"date"
#define MESSAGE_TO @"to"
#define MESSAGE_FROM @"from"
#define MESSAGE_ISREAD @"isRead"

@implementation Message

// Designated Initializer
-(id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self){
        self.title = data[MESSAGE_TITLE];
        self.content = data[MESSAGE_CONTENT];
        // TODO: init date
        self.date = data[MESSAGE_DATE];
        self.to = [[User alloc] initWithData:data[MESSAGE_TO]];
        self.from = [[User alloc] initWithData:data[MESSAGE_FROM]];
        self.isRead = data[MESSAGE_ISREAD];
    }
    return self;
}

-(id)init
{
    self = [self initWithData:nil];
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"[from:%@][to:%@][date:%@][message:%@]", self.from, self.to, self.date, self.content];
}

@end
