//
//  ChatViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ChatViewController : UIViewController<UITableViewDataSource>

- (void)updateUI;

@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property (strong, nonatomic) User *contact;
@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic, strong) NSString *accessToken;

@end
