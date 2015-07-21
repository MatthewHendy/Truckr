//
//  FavTableCell.m
//  Truckr
//
//  Created by Matthew Hendrickson on 7/21/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "FavTableCell.h"

@implementation FavTableCell

@synthesize truckTitleCellLabel = _truckTitleCellLabel;
@synthesize truckAddressCellLabel = _truckAddressCellLabel;
@synthesize thumbnailImageView = _thumbnailImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    NSLog(@"initWithStyle");
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _truckTitleCellLabel = [[UILabel alloc] init];
        _truckAddressCellLabel = [[UILabel alloc] init];
        
    }
    return self;
}


- (void)awakeFromNib {
    NSLog(@"awakefromNib");

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"setSelected");

    // Configure the view for the selected state
}

@end
