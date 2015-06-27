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
#import "YPAPISample.h"

@interface MapViewController ()
@property (retain, nonatomic) IBOutlet UITextField *quickSearchField;


@end

static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kBusinessPath      = @"/v2/business/";
static NSString * const kSearchLimit       = @"3";
static NSString * const searchLocation = @"Austin, TX";

@implementation MapViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //check for permissions
   
    
    //instantiate location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];

    //set map properties
    _map.delegate = self;
    [_map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];    
    [_map setCenterCoordinate:_map.userLocation.location.coordinate animated:YES];
    
    _quickSearchField.delegate = self;
 
    
    //[self dropPinOnAddress:@"4604 Duval St. Austin, TX 78751"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"enter pressed");
    if (textField.tag == 1) {
        [self yelp:_quickSearchField.text];
        return YES;
    }
    return NO;
}


-(void) yelp:(NSString*) searchParam {
    YPAPISample *APISample = [[YPAPISample alloc] init];
    dispatch_group_t requestGroup = dispatch_group_create();
    
    dispatch_group_enter(requestGroup);
    [APISample queryForArrayOfResults:searchParam location:searchLocation completionHandler:^(NSDictionary *resultsJSON, NSError *error) {
        
        if (error) {
            NSLog(@"An error happened during the request: %@", error);
        } else if (resultsJSON) {
            
            //this array will have the JSON's that have id's that contain the original user entered search term this trims down the returned trucks to ones that the user wants
            NSMutableArray* cutResults = [[NSMutableArray alloc] init];
            
            //NSLog(@"number of results %d", [resultsJSON count]);
            
            for(NSDictionary* d in resultsJSON) {
                if ([ d[@"id"] containsString:searchParam ]) {
                    //NSLog(@"id: %@", d[@"id"]);
                    [cutResults addObject:d];
                }
            }
            
            
            
            
            /*
            NSLog(@"Top business info: \n %@", topBusinessJSON);
            NSString* busId = topBusinessJSON[@"id"];
            NSLog(@"business id %@", busId);
            NSDictionary * location = topBusinessJSON[@"location"];
            NSLog(@"Top address info: \n %@", location);
            NSArray * addressParts = location[@"display_address"];
            NSLog(@"Top address parts info: \n %@",addressParts);
            
            NSString * address = [self appendFromArrayOfStrings:addressParts];
            NSLog(@"Top business address info: \n %@", address);

            */
            [self dropPinOnAddress:cutResults];

        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
}

- (NSString*) appendFromArrayOfStrings:(NSArray*) array {
    NSMutableString* address = [[NSMutableString alloc] init];

    for (NSString * string in array) {
        [address appendString:string];
        if ( !([string isEqualToString:[array lastObject]]) )
            [address  appendString: @", "];
    }
    NSString* ret = address;
    return ret;
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

- (void) dropPinOnAddress:(NSMutableArray*) array { //from Apple documentation. Source 1
    [self.map removeAnnotations:[self.map annotations]];
    for (NSDictionary* d in array) {
        
        NSDictionary * location = d[@"location"];
        //NSLog(@"Top address info: \n %@", location);
        NSArray * addressParts = location[@"display_address"];
        //NSLog(@"Top address parts info: \n %@",addressParts);
        
        NSString * address = [self appendFromArrayOfStrings:addressParts];
        NSLog(@"Top business address info: \n %@", address);
        
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = address;
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
             [self.map showAnnotations:placemarks animated:NO];
         }];
    }
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

- (void)dealloc {
    [_quickSearchField release];
    [super dealloc];
}
@end
