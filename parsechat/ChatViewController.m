//
//  ChatViewController.m
//  parsechat
//
//  Created by dkaviani on 7/6/20.
//  Copyright © 2020 dkaviani. All rights reserved.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chatMessageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:true];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}
- (IBAction)sendButton:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_fbu2019"];
    // Use the name of your outlet to get the text the user typed
    chatMessage[@"text"] = self.chatMessageField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            chatMessage[@"text"] = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
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

- (void)refresh {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_fbu2019"];
    [query includeKey:@"user"];
//    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages != nil) {
            self.messages = messages;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    PFObject *message = self.messages[indexPath.row];
    cell.messageLabel.text = message[@"text"];
    PFUser *user = message[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.nameLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.nameLabel.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

@end
