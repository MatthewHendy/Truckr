//
//  FavTableCell.h
//  Truckr
//
//  Created by Matthew Hendrickson on 7/21/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *truckTitleCellLabel;
@property (nonatomic, weak) IBOutlet UILabel *truckAddressCellLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
