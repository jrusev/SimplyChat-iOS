//
//  ContactsViewController.m
//  SimplyChat
//
//  Created by Jivko Rusev on 11/7/14.
//  Copyright (c) 2014 Jivko Rusev. All rights reserved.
//

#import "ContactsViewController.h"
#import "ChatViewController.h"
#import "DetailsViewController.h"
#import "ChatManager.h"

@interface ContactsViewController ()

@property (strong, nonatomic) ChatManager *chatManager;

@end

@implementation ContactsViewController

- (ChatManager *)chatManager {
    if (!_chatManager) _chatManager = [[ChatManager alloc] init];
    return _chatManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.navigationItem.hidesBackButton = YES;
    self.contactsTableView.dataSource = self;
    self.contactsTableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Segue to ChatViewController
    if ([segue.identifier isEqualToString:@"toChat"]) {
            
        NSIndexPath *path = sender;
        User *contact = self.users[path.row];
        
        ChatViewController *nextVC = segue.destinationViewController;
        nextVC.contact = contact;
        nextVC.accessToken = self.accessToken;
        nextVC.currentUser = self.currentUser;
        [self.chatManager getAllMessagesWithUser:contact token:self.accessToken callback:^(NSError *error, NSArray *messages) {
            if (error) {
                NSLog(@"[ContactsViewController] Error: %@", [error localizedDescription]);
                return;
            }
            if (nextVC) {
                // The callback may execute on any thread. Because operations
                // involving the UI are about to be performed, make sure they execute
                // on the main thread.
                dispatch_async(dispatch_get_main_queue(), ^{
                    nextVC.messages = [messages mutableCopy];
                    // tell the VC to reload its data
                    [nextVC updateUI];
                });
            }
        }];
    }
    
    // Segue to DetailsViewController
    if ([segue.identifier isEqualToString:@"toDetails"]) {
        
        NSIndexPath *path = sender;
        User *contact = self.users[path.row];
        
        DetailsViewController *nextVC = segue.destinationViewController;
        nextVC.contact = contact;
//        [self.chatManager getUserWithUsername:contact.username token:self.accessToken callback:^(NSError *error, User *user) {
//            if (error) {
//                NSLog(@"[ContactsViewController] Error: %@", [error localizedDescription]);
//                return;
//            }
//            if (nextVC) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    nextVC.contact = contact;
//                });
//            }
//        }];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toDetails" sender:indexPath];
}

// When the user taps a cell in the tableView
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"toChat" sender:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.contactsTableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    
    User *contact = self.users[indexPath.row];
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", contact.firstName, contact.lastName];
    [cell.textLabel setText:fullName];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

@end
