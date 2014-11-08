//
//  User.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// Designated Initializer
-(id)initWithData:(NSDictionary *)data;

-(NSString *)description;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;

@end
