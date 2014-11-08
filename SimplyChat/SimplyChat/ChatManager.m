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
#define URL_USERS_PROFILE @"/api/users/profile"
#define URL_USERS_ALL @"/api/users"
#define URL_MESSAGES_WITHUSER @"/api/messages/withUser"

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
    [self.requester httpPostWithURL:url content:content callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            NSString *accessToken = jsonObj[@"access_token"];
            callback(nil, accessToken);
        }
    }];
}

- (void)getCurrentUserWithAuth:(NSString *)accessToken callback:(void (^)(NSError *error, User *user))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_PROFILE];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *userData = [self getJson:data];
            User *currentUser = [[User alloc] initWithData:userData];
            callback(nil, currentUser);
        }
    }];
}

- (void)getAllUsersWithAuth:(NSString *)accessToken callback:(void (^)(NSError *error, NSArray *users))callback {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", accessToken] };
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_ALL];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            callback(error, nil);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
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
            NSMutableArray *messages = [NSMutableArray array];
            for (NSDictionary* data in jsonObj[@"messages"]) {
                [messages addObject:[[Message alloc] initWithData:data]];
            }
            callback(nil, messages);
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

@end
