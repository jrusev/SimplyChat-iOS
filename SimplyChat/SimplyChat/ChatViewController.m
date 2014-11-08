//
//  ChatViewController.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/8/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "ChatViewController.h"
#import "Message.h"
#import "ChatManager.h"

@interface ChatViewController ()

@property (strong, nonatomic) ChatManager *chatManager;

@end

@implementation ChatViewController

- (ChatManager *)chatManager {
    if (!_chatManager) _chatManager = [[ChatManager alloc] init];
    return _chatManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [self.contact description];
    self.messagesTableView.dataSource = self;
}

- (void)updateUI {
    [self.messagesTableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.messagesTableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    
    Message *message = self.messages[indexPath.row];
    [cell.textLabel setText:message.content];
    
    return cell;
}

- (IBAction)sendButtonPressed:(id)sender {
    NSString *message = self.messageTextField.text;
    if (!message.length) {
        return;
    }
    
    [self.chatManager sendMessageWithContent:message toUser:self.contact accessToken:self.accessToken callback:^(NSError *error, Message *message) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Message sent: %@", message);
        }
    }];
}

@end
