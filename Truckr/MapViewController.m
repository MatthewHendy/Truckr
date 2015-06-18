//
//  MapViewController.m
//  Truckr
//
//  Created by Mac OS on 6/15/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//
// Sources
// 1. used code from "Enabling Search"
//  https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/LocationAwarenessPG/EnablingSearch/EnablingSearch.html#//apple_ref/doc/uid/TP40009497-CH10-SW1

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //check for permissions
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //instantiate location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

    //set map properties
    _map.delegate = self;
    [_map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];    
    [_map setCenterCoordinate:_map.userLocation.location.coordinate animated:YES];
 
    [self quickSearch:@"4429 Duval St Austin TX 78751"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //check login information
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {//if logged in, great
        NSLog(@"current user is %@", currentUser.username);
    }
    else {
        //do modal segue to login view controller
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
    
}

- (void) quickSearch:(NSString*) query { //from Apple documentation. Source 1
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    request.region = self.map.region;
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
    {
        NSMutableArray *placemarks = [NSMutableArray array];
        for (MKMapItem *item in response.mapItems) {
            [placemarks addObject:item.placemark];
        }
        [self.map removeAnnotations:[self.map annotations]];
        [self.map showAnnotations:placemarks animated:NO];
    }];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        NSLog(@"still logged in");
    }
    else {
        NSLog(@"logged out");
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}



//useful code for dropping annotation points and setting regions
/*
 double lat = 30.30926;
 double lng = -97.723481;
 
 CLLocationCoordinate2D Coordinate;
 
 Coordinate.latitude = lat;
 Coordinate.longitude = lng;
 
 MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
 annotationPoint.coordinate = Coordinate;
 annotationPoint.title = @"my house";
 annotationPoint.subtitle = @"4604 Duval";
 //[self.map addAnnotation:annotationPoint];
 
 MKCoordinateRegion newRegion;
 newRegion.center.latitude = lat;
 newRegion.center.longitude = lng;
 [self.map setRegion:newRegion animated:YES];
 */



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
