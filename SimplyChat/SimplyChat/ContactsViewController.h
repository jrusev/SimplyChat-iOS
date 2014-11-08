//
//  ContactsViewController.h
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contactsTableView;
@property (strong, nonatomic) NSMutableArray *users;

@end
