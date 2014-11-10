//
//  LoginViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;

@end
