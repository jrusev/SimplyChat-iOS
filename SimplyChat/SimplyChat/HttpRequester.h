//
//  HttpRequester.h
//  HttpRequester
//
//  Created by JR on 11/4/14.
//
//

#import <Foundation/Foundation.h>

@interface HttpRequester : NSObject

- (void)httpPostWithURL:(NSString *)url content:(NSString *)content callback:(void (^)(NSError *error, NSData *data))callback;
- (void) httpGetWithURL:(NSString *)url
                headers:(NSDictionary *)headers
               callback:(void (^)(NSError *error, NSData *data))callback;

@end
