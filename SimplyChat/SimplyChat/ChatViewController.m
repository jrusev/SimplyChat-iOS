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

#define REFRESH_INTERVAL 1.0 // seconds

@interface ChatViewController ()

@property (strong, nonatomic) ChatManager *chatManager;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ChatViewController

- (NSTimer *) timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:REFRESH_INTERVAL target:self selector:@selector(onTimerTick:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (ChatManager *)chatManager {
    if (!_chatManager) _chatManager = [[ChatManager alloc] init];
    return _chatManager;
}

- (NSMutableArray *)messages {
    if (!_messages) _messages = [NSMutableArray array];
    return _messages;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [self.contact description];
    self.messagesTableView.dataSource = self;
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)onTimerTick:(NSTimer*)timer
{
    NSLog(@"Tick...");
    [self.chatManager getUnreadMessagesWithUser:self.contact token:self.accessToken callback:^(NSError *error, NSArray *messages) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }
        
        if (messages) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messages addObjectsFromArray:messages];
                [self updateUI];
            });
        }
    }];
}

- (void)updateUI {
    [self.messagesTableView reloadData];
    if (self.messagesTableView.contentSize.height > self.messagesTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.messagesTableView.contentSize.height - self.messagesTableView.frame.size.height);
        [self.messagesTableView setContentOffset:offset animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
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
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    cell.detailTextLabel.text = [formatter stringFromDate:message.date];
    
    return cell;
}

- (IBAction)sendButtonPressed:(id)sender {
    NSString *message = [self.messageTextField.text copy];
    if (!message.length) {
        return;
    }
    
    self.messageTextField.text = @"";
    [self.chatManager sendMessageWithContent:message toUser:self.contact accessToken:self.accessToken callback:^(NSError *error, Message *message) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"Message sent: %@", message);
            [self.messages addObject:message];
            [self updateUI];
        }
    }];
}

@end
