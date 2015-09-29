//
//  searchesTableCell.m
//  Truckr
//
//  Created by Matthew Hendrickson on 8/7/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "searchesTableCell.h"
#import "AppDelegate.h"
#import "MapViewController.h"

@implementation searchesTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addFavoritesButtonClicked:(id)sender {
    //now use cell properties to create a JSON acceptable dictionary like the truckInfo annotation does so I can save the truck to Parse
    
    NSMutableDictionary* dictForJSONConvert = [[NSMutableDictionary alloc] init];
    [dictForJSONConvert setValue:_cellTitle.text forKey:@"truckTitle"];
    [dictForJSONConvert setValue:_cellAddress.text forKey:@"truckAddress"];
    [dictForJSONConvert setValue:_imageURL forKey:@"imageURL"];
    [dictForJSONConvert setValue:_mobileURL forKey:@"mobileURL"];
    [dictForJSONConvert setValue:_displayPhone forKey:@"displayPhone"];
    
    AppDelegate* dele = [[UIApplication sharedApplication] delegate];
    
    if ([dele.localFavoriteArray containsObject:dictForJSONConvert]) {
        
        [self displayAlert:@"You already have that truck in your favorites list!!" message:@"D'oh  X__X"];
        return;
    }
    
    
    NSLog(@"BEFORE ADD\n%@",dele.localFavoriteArray);
    [dele.localFavoriteArray addObject:dictForJSONConvert];
    [dele saveFavArrToParse];
    NSLog(@"AFTER ADD\n%@",dele.localFavoriteArray);
    
    [self displayAlert:@"Truck added to your favorites list" message:@"√ √ √"];
    
}

-(void) displayAlert:(NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


@end
