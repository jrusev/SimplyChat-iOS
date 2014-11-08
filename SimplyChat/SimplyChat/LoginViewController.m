//
//  LoginViewController.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "LoginViewController.h"
#import "ContactsViewController.h"
#import "Notifier.h"

#define URL_AUTH_TOKEN @"/auth/token"
#define URL_USERS_PROFILE @"/api/users/profile"
#define URL_USERS_ALL @"/api/users"

@interface LoginViewController ()

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) HttpRequester *requester;

@end

static NSString *baseUrl = @"http://localhost:1337";

@implementation LoginViewController

- (HttpRequester *)requester {
    if (!_requester) _requester = [[HttpRequester alloc] init];
    return _requester;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id user = nil;
    if(user){
        [self segueToContacts];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toContacts"]) {
        // This will change the title on the next VC 'Back' button
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Log Out"
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
        ContactsViewController *nextVC = segue.destinationViewController;
        nextVC.users = [self.users mutableCopy];
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(!username.length) {
        [Notifier showAlert:@"Error" message:@"Username cannot be empty!" andBtn:@"OK"];
    }
    else if(!password.length) {
        [Notifier showAlert:@"Error" message:@"Password cannot be empty!" andBtn:@"OK"];
    } else {
        [self loginWithUserName:username andPassword:password];
    }
}

- (void)loginWithUserName:(NSString *)username andPassword:(NSString *)password {
    
    NSString *content = [NSString stringWithFormat:@"&grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@",
                         @"mobileV1", @"abc123456", username, password];
    
    NSString *url = [baseUrl stringByAppendingString:URL_AUTH_TOKEN];
    [self.requester httpPostWithURL:url content:content callback:^(NSError *error, NSData *data) {
        if (error) {
            NSLog(@"Connection error: %@", error);
        } else {
            [self receivedToken:data];
        }
    }];
}

#pragma mark - private methods

-(void)receivedToken:(NSData *)data {
    
    NSDictionary *jsonObj = [self getJson:data];
    self.accessToken = jsonObj[@"access_token"];     
    [self getUserProfile];
}

- (void)getUserProfile {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", self.accessToken] };
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_PROFILE];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            NSLog(@"Connection error: %@", error);
        } else {
            NSDictionary *user = [self getJson:data];
            NSLog(@"User profile: %@", user);
            [self getAllUsers];
        }
    }];
}

- (void)getAllUsers {
    NSDictionary *headers = @{ @"Authorization": [NSString stringWithFormat:@"Bearer %@", self.accessToken] };
    NSString *url = [baseUrl stringByAppendingString:URL_USERS_ALL];
    [self.requester httpGetWithURL:url headers:headers callback:^(NSError *error, NSData *data) {
        if (error) {
            NSLog(@"Connection error: %@", error);
        } else {
            NSDictionary *jsonObj = [self getJson:data];
            self.users = jsonObj[@"users"];
            [self segueToContacts];
        }
    }];
}

- (void)printData:(NSData *)data {
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@", dataString);
}

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

- (void)segueToContacts {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"toContacts" sender:self];
    });
}

@end
