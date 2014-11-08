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

#define REFRESH_INTERVAL 0.5 // seconds

@interface ChatViewController ()

@property (strong, nonatomic) ChatManager *chatManager;

@end

@implementation ChatViewController

NSTimer *_timer;
BOOL _initialLoad;

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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_INTERVAL target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [_timer fire];
    
    // The BOOL ivar initialLoad is set to TRUE in viewDidLoad.
    _initialLoad = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.messagesTableView.contentSize.height > self.messagesTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.messagesTableView.contentSize.height - self.messagesTableView.frame.size.height);
        [self.messagesTableView setContentOffset:offset animated:YES];
    }
}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    // on the initial cell load scroll to the last row (ie the latest Note)
//    if (_initialLoad == YES) {
//        _initialLoad = NO;
//        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messagesTableView numberOfRowsInSection:0] - 1) inSection:0];
//        [self.messagesTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//        CGPoint offset = CGPointMake(0, (1000000.0));
//        [self.messagesTableView setContentOffset:offset animated:NO];
//    }
//}


//-(void)goToBottom
//{
//    NSIndexPath *lastIndexPath = [self lastIndexPath];
//    [self.messagesTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//}
//
//-(NSIndexPath *)lastIndexPath
//{
//    NSInteger lastSectionIndex = MAX(0, [self.messagesTableView numberOfSections] - 1);
//    NSInteger lastRowIndex = MAX(0, [self.messagesTableView numberOfRowsInSection:lastSectionIndex] - 1);
//    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
//}

- (void) update:(id)sender {
    [self.chatManager getAllMessagesWithUser:self.contact token:self.accessToken callback:^(NSError *error, NSArray *messages) {
        if (error) {
            NSLog(@"Error: %@", error);
            return;
        }

        self.messages = [messages mutableCopy];
        [self updateUI];
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
