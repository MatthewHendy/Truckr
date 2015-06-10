//
//  Truckr
//
//  Created by Matthew Hendrickson on 6/5/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"current user is %@", currentUser.username);
    }
    else {
        NSLog(<#NSString *format, ...#>)
    }
    
    }

- (IBAction)logInButton:(id)sender {
    
    NSLog(@"username: %@\npw: %@",_LoginUsername.text,_LoginPassword.text);
    
    if (!_LoginUsername.text) {
        NSLog(@"enter a username");
    }
    if (!_LoginPassword.text) {
        NSLog(@"enter a password");
    }
    
    [PFUser logInWithUsernameInBackground:_LoginUsername.text password:_LoginPassword.text block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"logged in");
        }
        else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
        }
    }];
    
}


- (IBAction)signupButtonClicked:(id)sender {
    NSLog(@"button clicked");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
