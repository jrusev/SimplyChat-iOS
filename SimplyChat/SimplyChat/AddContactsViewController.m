//
//  AddContactsViewController.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/10/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "AddContactsViewController.h"

@interface AddContactsViewController ()

@end

@implementation AddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Nav bar buttons
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addButtonPressed:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton, nil];
}

- (void)addButtonPressed:(id)sender {
    // TODO: Search for contacts
}


@end
