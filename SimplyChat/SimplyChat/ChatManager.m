//
//  ChatManager.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "ChatManager.h"
#import "HttpRequester.h"

#define URL_AUTH_TOKEN @"/auth/token"
#define URL_USERS_CURRENTUSER @"/api/users/currentUser"
#define URL_USERS_BYUSERNAME @"/api/users/byUsername"
#define URL_USERS_CONTACTS @"/api/users/contacts"
#define URL_USERS_REGISTER @"/api/users/register"

#define URL_MESSAGES_WITHUSER @"/api/messages/withUser"
#define URL_MESSAGES_SEND @"/api/messages/send"


@interface ChatManager ()

@property (nonatomic, strong) HttpRequester *requester;

@end

static NSString *baseUrl = @"http://localhost:1337";

@implementation ChatManager

- (HttpRequester *)requester {
    if (!_requester) _requester = [[HttpRequester alloc] init];
    return _requester;
}

- (void)loginWithUserName:(NSString *)username password:(NSString *)password callback:(void (^)(NSError *error, NSString *accessToken))callback {
    
    NSString *content = [NSString stringWithFormat:@"&grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",
                         @"mobileV1", @"abc123456", username, password];
    
    NSString *url = [baseUrl stringByAppendingString:URL_AUTH_TOKEN];
    [self.requester httpPostWithURL:url headers:nil content:content callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            NSString *accessToken = jsonObj[@"access_token"];
            callback(nil, accessToken);
        }
    }];
}

- (void)registerWithUserName:(NSString *)username
                    password:(NSString *)password
                   firstName:(NSString *)firstName
                    lastName:(NSString *)lastName
                    location:(NSString *)location
                    imageUrl:(NSString*)imageUrl
                    callback:(void (^)(NSError *error, User *user))callback {
    
    NSString *content = [NSString stringWithFormat:@"&username=%@&password=%@&firstName=%@&lastName=%@&location=%@&imageUrl=%@",
                         username, password, firstName, lastName, location,imageUrl];
    
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_REGISTER];
    [self.requester httpPostWithURL:url headers:nil content:content callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            User *registeredUser = [[User alloc] initWithData:jsonObj];
            callback(nil, registeredUser);
        }
    }];
}

- (void)getCurrentUserWithToken:(NSString *)accessToken callback:(void (^)(NSError *error, User *user))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_CURRENTUSER];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            User *currentUser = [[User alloc] initWithData:jsonObj];
            callback(nil, currentUser);
        }
    }];
}

- (void)getUserWithUsername:(NSString *)username token:(NSString *)accessToken callback:(void (^)(NSError *error, User *user))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", baseUrl, URL_USERS_BYUSERNAME, username];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            User *currentUser = [[User alloc] initWithData:jsonObj];
            callback(nil, currentUser);
        }
    }];
}

- (void)getContactsWithToken:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *users))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_CONTACTS];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            NSMutableArray *users = [NSMutableArray array];
            for (NSDictionary* data in jsonObj[@"users"]) {
                [users addObject:[[User alloc] initWithData:data]];
            }
            callback(nil, users);
        }
    }];
}

- (void)getAllMessagesWithUser:(User *)user token:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *messages))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", baseUrl, URL_MESSAGES_WITHUSER, user.username];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            NSMutableArray *messages = [NSMutableArray array];
            for (NSDictionary* data in jsonObj[@"messages"]) {
                [messages addObject:[[Message alloc] initWithData:data]];
            }
            callback(nil, messages);
        }
    }];
}

- (void)getUnreadMessagesWithUser:(User *)user token:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *messages))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [NSString stringWithFormat:@"%@%@/%@?unread=true", baseUrl, URL_MESSAGES_WITHUSER, user.username];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            NSMutableArray *messages = [NSMutableArray array];
            for (NSDictionary* data in jsonObj[@"messages"]) {
                [messages addObject:[[Message alloc] initWithData:data]];
            }
            callback(error, messages.count ? messages : nil);
        }
    }];
}

- (void)sendMessageWithContent:(NSString *)content
             toUser:(User *)toUser
        accessToken:(NSString *)accessToken
           callback:(void (^)(NSError *error, Message *message))callback
{
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *contentEncoded = [NSString stringWithFormat:@"&title=%@&content=%@", @"no title", content];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", baseUrl, URL_MESSAGES_SEND, toUser.username];
    
    [self.requester httpPostWithURL:url headers:headers content:contentEncoded callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            
            if (jsonObj[@"error"]) {
                NSError *error = [self createErrorWithMessage:jsonObj[@"error"]];
                callback(error, nil);
                return;
            }
            
            Message *messageFromDb = [[Message alloc] initWithData:jsonObj[@"message"]];
            callback(nil, messageFromDb);
        }
    }];
}

#pragma mark - private

- (NSDictionary *)getJson:(NSData *)data {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error || ![object isKindOfClass:[NSDictionary class]]) {
        NSLog(@"There was a problem deserializing from JSON");
        return nil;
    }
    
    NSDictionary *results = object;
    return results;
}

- (NSError *)createErrorWithMessage:(NSString *)message {
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:message forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"HttpRequest" code:400 userInfo:details];
    return error;
}

@end
