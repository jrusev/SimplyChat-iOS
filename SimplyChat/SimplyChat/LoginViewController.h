//
//  LoginViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequester.h"

@interface LoginViewController : UIViewController<HttpRequesterDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonPressed:(id)sender;
- (void)loginWithUserName:(NSString *)username andPassword:(NSString *)password;

@end
