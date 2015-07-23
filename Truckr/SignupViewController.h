//
//  SignupViewController.h
//  Truckr
//
//  Created by Matthew Hendrickson on 6/8/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignupViewController : UIViewController
@property (nonatomic) IBOutlet UITextField *username;
@property (nonatomic) IBOutlet UITextField *pw;
@property (nonatomic) IBOutlet UITextField *confirmPw;
@property (nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *SignUpButton;

@end
