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
    
    _nameLabel = [[UILabel alloc] init];
    
    //_imageView.image = self.imageView;
    _nameLabel.text = self.nameLabel.text;
    _addressLabel.text = self.addressLabel.text;
    _phoneLabel.text = self.phoneLabel.text;
    _mobileURLLabel.text = self.mobileURLLabel.text;
    
    
    NSLog(@"in truckVC\nnameLabel: %@\nadressLabel: %@\nphoneLabel: %@\nmobileLabel: %@",_nameLabel.text,_addressLabel.text,_phoneLabel.text,_mobileURLLabel.text);
    
    // Do any additional setup after loading the view.
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
