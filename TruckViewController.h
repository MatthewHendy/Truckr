//
//  TruckViewController.h
//  Truckr
//
//  Created by Matthew Hendrickson on 7/22/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TruckViewController : UIViewController

@property (weak, nonatomic) NSString* nameText;
@property (weak, nonatomic) NSString* addressText;
@property (weak, nonatomic) NSString* phoneText;
@property (weak, nonatomic) NSString* mobileURLText;
@property (weak, nonatomic) NSString* imageURLText;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileURLLabel;




@end
