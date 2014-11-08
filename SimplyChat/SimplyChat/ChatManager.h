//
//  ChatManager.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ChatManager : NSObject

- (void)loginWithUserName:(NSString *)username password:(NSString *)password callback:(void (^)(NSError *error, NSString *accessToken))callback;
- (void)getCurrentUserWithAuth:(NSString *)accessToken callback:(void (^)(NSError *error, User *user))callback;
- (void)getAllUsersWithAuth:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *users))callback;

@end
