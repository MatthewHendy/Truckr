//
//  MapViewController.h
//  Truckr
//
//  Created by Mac OS on 6/15/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import <MapKit/MapKit.h>
#import "TruckCallout.h"
#import "TruckInfo.h"
#import "searchesTableCell.h"
#import "TruckViewController.h"
#import "MapViewController.h"
#import "Reachability.h"





@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) TruckCallout* callout;
@property (retain, nonatomic) IBOutlet UITextField *quickSearchField;

@property (strong, nonatomic) IBOutlet UITableView *searchesTable;
@property (nonatomic) NSMutableArray* searchesArray;

-(void) displayAlert:(NSString*) title message:(NSString*) message;



@end
