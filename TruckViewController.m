//
//  TruckViewController.m
//  Truckr
//
//  Created by Matthew Hendrickson on 7/22/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "TruckViewController.h"

@interface TruckViewController ()

@end

@implementation TruckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *logo = [UIImage imageNamed:@"truck-icon"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];

    
    //_imageView.image = self.imageView;
    _nameText = self.nameText;
    _addressText = self.addressText;
    _phoneText = self.phoneText;
    _mobileURLText = self.mobileURLText;
    _imageURLText = self.imageURLText;
    
    
    _nameLabel.text = _nameText;
    _addressLabel.text = _addressText;
    _phoneLabel.text = _phoneText;
    [_mobileURLLabel setTitle:_mobileURLText forState:UIControlStateNormal];
    _imageView.image = [UIImage imageWithData:
                [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: _imageURLText]]];
    
    
    NSLog(@"in truckVC\nnameLabel: %@\nadressLabel: %@\nphoneLabel: %@\nmobileLabel: %@",_nameLabel.text,_addressLabel.text,_phoneLabel.text,_mobileURLLabel.titleLabel.text);
    
    // Do any additional setup after loading the view.
}


- (IBAction)mobileURLPressed:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_mobileURLText]];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
