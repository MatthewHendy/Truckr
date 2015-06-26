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


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) IBOutlet UISlider *SearchDistSlider;


@end
