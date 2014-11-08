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
#import "User.h"
#import "ChatManager.h"

@interface LoginViewController ()

@property (nonatomic, strong) ChatManager *chatManager;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation LoginViewController

- (ChatManager *)chatManager {
    if (!_chatManager) _chatManager = [[ChatManager alloc] init];
    return _chatManager;
}

- (NSMutableArray *)users {
    if (!_users) _users = [NSMutableArray array];
    return _users;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    id user = nil;
    if(user){
        [self segueToContacts];
    }
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
        nextVC.accessToken = self.accessToken;
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
        [self.chatManager loginWithUserName:username password:password callback:^(NSError *error, NSString *accessToken) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                self.accessToken = accessToken;
                NSLog(@"access_token: %@", accessToken);
                [self getUserProfile];
            }
        }];
    }
}

#pragma mark - private methods

- (void)getUserProfile {
  
    [self.chatManager getCurrentUserWithToken:self.accessToken callback:^(NSError *error, User *user) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.currentUser = user;
            NSLog(@"Successful login: %@", user);
            [self getAllUsers];
        }
    }];
}

- (void)getAllUsers {
  
    [self.chatManager getAllUsersWithToken:self.accessToken callback:^(NSError *error, NSArray *users) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.users = [users mutableCopy];
            [self segueToContacts];
        }
    }];
}

- (void)printData:(NSData *)data {
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response received: %@", dataString);
}

- (void)segueToContacts {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"toContacts" sender:self];
    });
}

@end
