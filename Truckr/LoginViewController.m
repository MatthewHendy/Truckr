//
//  Truckr
//
//  Created by Matthew Hendrickson on 6/5/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *logo = [UIImage imageNamed:@"truck-icon"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    //if user taps away from text field the app dismisses the keyboard
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    
    _SignupButton.layer.cornerRadius = 10;
    _SignUpLabel.layer.cornerRadius = 10;
    _SignUpLabel.clipsToBounds= YES;
    _LogInButton.layer.cornerRadius = 10;
    
    
    _LoginUsername.delegate = self;
    _LoginPassword.delegate = self;
}


-(void) dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void) displayAlert:(NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"login screen enter pressed");
    [self logInButton:nil];
    [textField resignFirstResponder];
    return YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
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
            
            PFQuery *query = [PFQuery queryWithClassName:@"PFFavoriteArray"];
            [query whereKey:@"user" equalTo:user];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                
                
                if(object != nil || object != Nil) {
                    
                    
                    AppDelegate* dele = [[UIApplication sharedApplication] delegate];
                    
                    dele.localFavoriteArray = object[@"favoriteArray"];
                    
                    NSLog(@"after signing in with different account favoriteArray count %lu", [object[@"favoriteArray"] count]);
                    NSLog(@"after signing in with different account\n%@", dele.localFavoriteArray);
                    
                    [[self navigationController] popViewControllerAnimated:YES];
                    
                }
                else {
                    NSLog(@"yo object is nil or Nil");
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    [self displayAlert:@"Error Logging In" message:errorString];
                }
                
            }];
            
            
            
        }
        else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            [self displayAlert:@"Error Logging In" message:errorString];

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
