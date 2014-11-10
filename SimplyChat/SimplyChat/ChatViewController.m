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
#import "Notifier.h"

#define REFRESH_INTERVAL 1.0 // seconds

@interface ChatViewController ()

@property (strong, nonatomic) ChatManager *chatManager;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL firstLoad;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

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

    self.navigationItem.title = [self.contact description];
    self.messagesTableView.dataSource = self;
    // Start the update timer
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.firstLoad = YES;
    [self registerForKeyboardNotifications];
    self.messageTextField.delegate = self;
    
    // Location manager
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        //[self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"[ChatViewController] Location services not enabled!");
    }
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self freeKeyboardNotifications];
}

- (void)onTimerTick:(NSTimer*)timer
{
    NSLog(@"Tick...");
    [self.chatManager getUnreadMessagesWithUser:self.contact token:self.accessToken callback:^(NSError *error, NSArray *messages) {
        if (error) {
            NSLog(@"[ChatViewController] Error: %@", [error localizedDescription]);
            return;
        }
        
        if (messages) {
            NSLog(@"Unread messages: %@",messages);
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
  
    NSInteger row = indexPath.row;
 
    Message *message = self.messages[row];
    [cell.textLabel setText:message.content];
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *formattedDate =[ formatter stringFromDate:message.date];
    cell.detailTextLabel.text = formattedDate;
    
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
    
    BOOL fromCurrentUser = [message.from.username isEqualToString:self.currentUser.username];
   
    // Content
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 5, 240, 30)];
    [lbl1 setFont:[UIFont fontWithName:@"Helvetica Neue" size:16.0]];
    [lbl1 setTextColor:[UIColor blackColor]];
    lbl1.text = message.content;
    [cell addSubview:lbl1];
    
    // Date
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(260, 0, 150, 30)];
    [lbl2 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [lbl2 setTextColor:[UIColor grayColor]];
    lbl2.text = formattedDate;
    [cell addSubview:lbl2];
    
    // Author
    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(260, 15, 150, 30)];
    [lbl3 setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    [lbl3 setTextColor:[UIColor grayColor]];
    lbl3.text = fromCurrentUser ? @"me" : message.from.firstName;
    [cell addSubview:lbl3];
    
    // fix for separators

    if (fromCurrentUser ) {
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
    [self.messageTextField resignFirstResponder];
    
    NSString *message = [self.messageTextField.text copy];
    if (!message.length) {
        return;
    }
    
    self.messageTextField.text = @"";
    [self.chatManager sendMessageWithContent:message toUser:self.contact accessToken:self.accessToken callback:^(NSError *error, Message *message) {
        if (error) {
            NSLog(@"[ChatViewController] Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Message sent: %@", message);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messages addObject:message];
                [self updateUI];
            });
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButtonPressed:nil];
    return NO;
}

#pragma mark - show/hide the keyboard

- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
    [self sendButtonPressed:nil];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    // Move
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.messagesTableView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+ keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height-keyboardFrame.size.height)];
    [self.messagesTableView scrollsToTop];
    [UIView commitAnimations];
    
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    // Move
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [self.messagesTableView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

#pragma mark - CLLocationManagerDelegate

- (IBAction)locationButtonPressed:(id)sender {
    //[Notifier showAlert:@"Location" message:@"Your location is being sent!" andBtn:@"OK"];
    [self.locationManager startUpdatingLocation];
    NSLog(@"startUpdatingLocation");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    NSLog(@"stopUpdatingLocation");
    
    NSString *locationMessage = [NSString stringWithFormat:@"Lat :%0.4f Lon: %.4f",
                                 self.location.coordinate.latitude, self.location.coordinate.longitude ];
    
    NSLog(@"%@", locationMessage );
    [self.chatManager sendMessageWithContent:locationMessage toUser:self.contact accessToken:self.accessToken callback:^(NSError *error, Message *message) {
        if (error) {
            NSLog(@"[ChatViewController] Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Message sent: %@", message);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messages addObject:message];
                [self updateUI];
            });
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"LocationManager failed with error: %@", [error localizedDescription]);
    [self.locationManager stopUpdatingLocation];
}

@end
