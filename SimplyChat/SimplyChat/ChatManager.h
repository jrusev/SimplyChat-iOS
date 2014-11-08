//
//  ChatManager.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Message.h"

@interface ChatManager : NSObject

- (void)loginWithUserName:(NSString *)username password:(NSString *)password callback:(void (^)(NSError *error, NSString *accessToken))callback;
- (void)getCurrentUserWithToken:(NSString *)accessToken callback:(void (^)(NSError *error, User *user))callback;
- (void)getAllUsersWithToken:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *users))callback;
- (void)getAllMessagesWithUser:(User *)user token:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *messages))callback;
- (void)sendMessageWithContent:(NSString *)content
             toUser:(User *)toUser
        accessToken:(NSString *)accessToken
           callback:(void (^)(NSError *error, Message *message))callback;
@end
