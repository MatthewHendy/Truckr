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
@property (weak, nonatomic) IBOutlet UITextField *LoginUsername;
@property (weak, nonatomic) IBOutlet UITextField *LoginPassword;
@property (weak, nonatomic) IBOutlet UILabel *SignUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *SignupButton;


@end

