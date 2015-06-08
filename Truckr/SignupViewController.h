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
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *pw;
@property (weak, nonatomic) IBOutlet UITextField *confirmPw;
@property (weak, nonatomic) IBOutlet UITextField *email;

@end
