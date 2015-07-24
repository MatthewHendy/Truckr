//
//  FavoritesTable.m
//  Truckr
//
//  Created by Matthew Hendrickson on 7/12/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "FavoritesTable.h"
#import "AppDelegate.h"
#import "TruckViewController.h"


@interface FavoritesTable ()

@end

@implementation FavoritesTable


- (void)viewDidLoad {
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate* dele = [[UIApplication sharedApplication] delegate];
    _favoritesArray = dele.localFavoriteArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    //NSLog(@"numRows is %d",[_favoritesArray count] );

    return [_favoritesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary* t = _favoritesArray[indexPath.row];
    
    NSString* title = t[@"truckTitle"];
    NSString* address = t[@"truckAddress"];
    NSString* image = t[@"imageURL"];
    UIImage* myImage = [UIImage imageWithData:
                [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: image]]];
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = address;
    cell.imageView.image = myImage;
    
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    if ([[segue identifier] isEqualToString:@"showTruckVC"]) {

    
        NSLog(@"1");
    
        TruckViewController *vc = (TruckViewController *) [segue destinationViewController];

        // Pass the selected object to the new view controller.
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        NSDictionary* t = _favoritesArray[indexPath.row];
        NSLog(@"dict\n%@",t);
    
        vc.nameText = t[@"truckTitle"];
        vc.addressText = t[@"truckAddress"];
        vc.phoneText = t[@"displayPhone"];
        vc.mobileURLText = t[@"mobileURL"];
        vc.imageURLText = t[@"imageURL"];
    
        /*vc.imageView.image = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: image]]];*/
    
        NSLog(@"in favTable\nnameLabel: %@\nadressLabel: %@\nphoneLabel: %@\nmobileLabel: %@",vc.nameText,vc.addressText,vc.phoneText,vc.mobileURLText);
        
    }

}


@end
