//
//  searchesTableCell.h
//  Truckr
//
//  Created by Matthew Hendrickson on 8/7/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchesTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellAddress;
@property (weak, nonatomic) NSString* imageURL;
@property (weak, nonatomic) NSString* mobileURL;
@property (weak, nonatomic) NSString* displayPhone;
@property (weak, nonatomic) IBOutlet UIButton *addFavoritesButton;

@property (nonatomic) int row;

@end
