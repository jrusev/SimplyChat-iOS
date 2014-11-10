//
//  ChatViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import <CoreLocation/CoreLocation.h>

@interface ChatViewController : UIViewController<UITableViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate>

- (void)updateUI;

@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) User *contact;
@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic, strong) NSString *accessToken;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (nonatomic, strong) User *currentUser;

-(IBAction)sendButtonPressed:(id)sender;
-(IBAction) textFieldDoneEditing:(id) sender;

-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;

@end
