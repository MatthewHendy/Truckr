//
//  SignupViewController.m
//  Truckr
//
//  Created by Matthew Hendrickson on 6/8/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()


@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"username: '%@'",_username.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)signup:(id)sender {
    
    NSLog(@"username: %@\npw:%@\nconfpw: %@\nemail:%@",_username.text,_pw.text,_confirmPw.text,_email.text);
    
    if ([_username.text isEqualToString:@""]) {
        NSLog(@"enter a username");
        return;
    }
    if ([_pw.text isEqualToString:@""]){
        NSLog(@"enter a password");
        return;
    }
    if ([_confirmPw.text isEqualToString:@""]) {
        NSLog(@"enter a confirm password");
        return;
    }
    if (![_pw.text isEqualToString:_confirmPw.text]) {
        NSLog(@"the password and confirm password dont match");
        return;
    }
    if ([_email.text isEqualToString:@""]) {
        NSLog(@"enter an email");
        return;
    }
        
    
    
    PFUser *user = [PFUser user];
    user.username = _username.text;
    user.password = _pw.text;
    user.email = _email.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"signed up!!");
            //display alertView
            [[self navigationController] popToRootViewControllerAnimated:YES];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
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

@end
