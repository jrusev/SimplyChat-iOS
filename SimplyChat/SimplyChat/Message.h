//
//  Message.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Message : NSObject

// Designated Initializer
-(id)initWithData:(NSDictionary *)data;

-(NSString *)description;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) User *to;
@property (nonatomic, strong) User *from;
@property BOOL isRead;

@end
