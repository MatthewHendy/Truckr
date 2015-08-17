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
    [_phoneButton setTitle:_phoneText forState:UIControlStateNormal];
    [_mobileURLLabel setTitle:_mobileURLText forState:UIControlStateNormal];
    _imageView.image = [UIImage imageWithData:
                [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: _imageURLText]]];
    
    _nameLabel.layer.cornerRadius = 10;
    _addressLabel.layer.cornerRadius = 10;
    _phoneButton.layer.cornerRadius = 10;
    _mobileURLLabel.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 10;
    
    _nameLabel.layer.borderWidth = 2.0f;
    _nameLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _addressLabel.layer.borderWidth = 2.0f;
    _addressLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _phoneButton.layer.borderWidth = 2.0f;
    _phoneButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _mobileURLLabel.layer.borderWidth = 2.0f;
    _mobileURLLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    _imageView.layer.borderWidth = 2.0f;
    _imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    if (!_nameLabel.text)
        _nameLabel.text = @"There isn't a listed name";
    if (!_addressLabel.text)
        _addressLabel.text = @"There isn't a listed address";
    if (!_phoneButton.titleLabel.text)
        [_phoneButton setTitle:@"There isn't a listed phone number" forState:UIControlStateNormal];
    if (!_mobileURLLabel.titleLabel.text)
        [_phoneButton setTitle:@"There isn't a URL for the website" forState:UIControlStateNormal];
    if (!_imageURLText)
        _imageView.image = [UIImage imageNamed:@"defaultTruck"];
    
    NSLog(@"in truckVC\nnameLabel: %@\nadressLabel: %@\nphoneLabel: %@\nmobileLabel: %@",_nameLabel.text,_addressLabel.text,_phoneButton.titleLabel.text,_mobileURLLabel.titleLabel.text);
    
    // Do any additional setup after loading the view.
}


- (IBAction)phoneButtonPressed:(id)sender {
    NSString *cleanedNumber = [[_phoneText componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    //NSLog(@"calling %@",cleanedNumber);

    NSString *finalProduct = [@"telprompt://" stringByAppendingString:cleanedNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:finalProduct]];


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
