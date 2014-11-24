//
//  RegisterViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/10/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewControllerDelegate <NSObject>

- (void)setUsername:(NSString *)username andPassword:(NSString *)password;

@end

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextField *imageUrlTextField;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak,nonatomic) id<RegisterViewControllerDelegate> delegate;
- (IBAction)registerButtonPressed:(id)sender;

@end
