//
//  SignupViewController.m
//  Truckr
//
//  Created by Matthew Hendrickson on 6/8/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "SignupViewController.h"
#import "AppDelegate.h"

@interface SignupViewController ()


@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *logo = [UIImage imageNamed:@"finaltruckriconclear"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    //if user taps away from text field the app dismisses the keyboard
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    _SignUpButton.layer.cornerRadius = 10;
    
    _username.delegate = self;
    _pw.delegate = self;
    _confirmPw.delegate = self;
    _email.delegate = self;
    
    
    NSLog(@"username: '%@'",_username.text);
}

-(void) dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void) displayAlert:(NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"signup screen enter pressed");
    [self signup:nil];
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)signup:(id)sender {
    
    NSLog(@"username: %@\npw:%@\nconfpw: %@\nemail:%@",_username.text,_pw.text,_confirmPw.text,_email.text);
    
    if ([_username.text isEqualToString:@""]) {
        NSLog(@"enter a username");
        [self displayAlert:@"You Forgot Something..." message:@"enter a username"];
        return;
    }
    if ([_pw.text isEqualToString:@""]){
        [self displayAlert:@"You Forgot Something..." message:@"Enter a Passsword"];
        return;
    }
    if ([_confirmPw.text isEqualToString:@""]) {
        [self displayAlert:@"You Forgot Something..." message:@"Confirm your Password"];
        return;
    }
    if (![_pw.text isEqualToString:_confirmPw.text]) {
        [self displayAlert:@"So Sorry" message:@"The Password and Confirm Password Don't Match"];
        return;
    }
    if ([_email.text isEqualToString:@""]) {
        [self displayAlert:@"You Forgot Something..." message:@"Enter an Email"];
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
            //create the PFFavoriteArray PFObject that will store the array of favorite trucks with each user.
            PFObject* PFFavoriteArray = [PFObject objectWithClassName:@"PFFavoriteArray"];
            PFFavoriteArray[@"user"] = user;
            PFFavoriteArray[@"favoriteArray"] = [[NSArray alloc] init];
            [PFFavoriteArray saveInBackground];
            
            AppDelegate* dele = [[UIApplication sharedApplication] delegate];
            dele.localFavoriteArray = [[NSMutableArray alloc] init];
            
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
