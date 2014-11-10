//
//  RegisterViewController.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/10/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "RegisterViewController.h"
#import "Notifier.h"
#import "ChatManager.h"

@interface RegisterViewController ()

@property (nonatomic, strong) ChatManager *chatManager;

@end

@implementation RegisterViewController

- (ChatManager *)chatManager {
    if (!_chatManager) _chatManager = [[ChatManager alloc] init];
    return _chatManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.passwordTextField.secureTextEntry = YES;
    
    // Handle right swipe gesture
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onRightSwipe)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)onRightSwipe {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)registerButtonPressed:(id)sender {
    NSString *firstName = self.firstNameTextField.text;
    NSString *lastName = self.lastNameTextField.text;
    
    NSString *location = self.locationTextField.text;
    NSString *imageUrl = self.imageUrlTextField.text;    
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if(!firstName.length) {
        [Notifier showAlert:@"Error" message:@"First name cannot be empty!" andBtn:@"OK"];
        return;
    }
    
    if(!lastName.length) {
        [Notifier showAlert:@"Error" message:@"Last name cannot be empty!" andBtn:@"OK"];
        return;
    }
    
    if(!username.length) {
        [Notifier showAlert:@"Error" message:@"Username cannot be empty!" andBtn:@"OK"];
        return;
    }
    
    if(!password.length) {
        [Notifier showAlert:@"Error" message:@"Password cannot be empty!" andBtn:@"OK"];
        return;
    }
    
    [self.view endEditing:YES];
    [self.chatManager registerWithUserName:username
                                  password:password
                                 firstName:firstName
                                  lastName:lastName
                                  location:location
                                  imageUrl:imageUrl
                                  callback:^(NSError *error, User *user) {
        if (error) {
            NSLog(@"[RegisterViewController] Error: %@", [error localizedDescription]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Notifier showAlert:@"Error" message:[error localizedDescription] andBtn:@"OK"];
            });
        } else {
            NSLog(@"[RegisterViewController] User registered: %@", user);
            dispatch_async(dispatch_get_main_queue(), ^{
                [Notifier showAlert:@"Success" message:@"You have made a successful registration!" andBtn:@"OK"];                
            });
        }
  }];

}
@end
