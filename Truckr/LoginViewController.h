//
//  ViewController.h
//  Truckr
//
//  Created by Matthew Hendrickson on 6/5/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SignupViewController.h"

@interface LoginViewController : UIViewController
@property (nonatomic) IBOutlet UITextField *LoginUsername;
@property (nonatomic) IBOutlet UITextField *LoginPassword;
@property (nonatomic) IBOutlet UILabel *SignUpLabel;
@property (nonatomic) IBOutlet UIButton *SignupButton;
@property (weak, nonatomic) IBOutlet UIButton *LogInButton;


@end

