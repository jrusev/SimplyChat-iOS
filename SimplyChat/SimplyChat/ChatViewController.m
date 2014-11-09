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
@property (nonatomic) BOOL firstLoad;

- (void)onTimerTick:(NSTimer*)timer;

@end

@implementation ChatViewController

#pragma mark - properties

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

#pragma mark - View management
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [self.contact description];
    self.messagesTableView.dataSource = self;
    // Start the update timer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.firstLoad = YES;
}

- (void)updateUI {
    [self.messagesTableView reloadData];
    if (self.messagesTableView.contentSize.height > self.messagesTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.messagesTableView.contentSize.height - self.messagesTableView.frame.size.height);
        [self.messagesTableView setContentOffset:offset animated:!self.firstLoad];
        self.firstLoad = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
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
            NSLog(@"%@",messages);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messages addObjectsFromArray:messages];
                [self updateUI];
            });
        }
    }];
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
    NSString *formattedDate =[ formatter stringFromDate:message.date];
    cell.detailTextLabel.text = formattedDate;
    
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
    
   
    // Content
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, 150, 30)];
    [lbl1 setFont:[UIFont fontWithName:@"Helvetica Neue" size:18.0]];
    [lbl1 setTextColor:[UIColor blackColor]];
    lbl1.text = message.content;
    [cell addSubview:lbl1];
    
    // Date
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(260, 0, 150, 30)];
    [lbl2 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [lbl2 setTextColor:[UIColor grayColor]];
    lbl2.text = formattedDate;
    [cell addSubview:lbl2];
    
    // Date
    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(260, 15, 150, 30)];
    [lbl3 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [lbl3 setTextColor:[UIColor grayColor]];
    lbl3.text = message.from.firstName;
    [cell addSubview:lbl3];
    
    // fix for separators

    if ([message.from.username isEqualToString:self.currentUser.username]) {
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:1.0 alpha:1];
        lbl1.textColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor whiteColor];
    }
   
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
