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
#import "AppDelegate.h"

@interface MapViewController ()

@property (nonatomic) NSMutableArray* searchesArray;

@end


static NSString * const searchLocation = @"Austin, TX";

@implementation MapViewController

@synthesize searchesTable;


//Table View code
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numRows is %d",[_searchesArray count] );
    return [_searchesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    searchesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary* t = _searchesArray[indexPath.row];
    
    //get location and parse address
    NSDictionary * location = t[@"location"];
    NSArray * addressParts = location[@"display_address"];
    NSString * address = [self appendFromArrayOfStrings:addressParts];//final address
    
    //get name and parse it
    NSString* name = t[@"id"];
    name = [name stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    name = [name capitalizedString];//final name

    //get imageURL and put it into a UIImage
    NSString* image = t[@"image_url"];
    UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: image]]];
    
    
    cell.cellTitle.text = name;
    cell.cellAddress.text = address;
    cell.cellImage.image = myImage;
    cell.imageURL = image;
    cell.mobileURL = t[@"mobile_url"];
    cell.displayPhone = t[@"display_phone"];
    cell.row = indexPath.row;
    
    NSLog(@"here in cellForRow %d\nname: %@\naddress: %@\n\n",[_searchesArray count],name, address);
    //NSLog(@"here in cellForRow 2\nname: %@\naddress: %@\n\n",cell.textLabel.text, cell.detailTextLabel.text);

    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //check for permissions
    NSLog(@"instantiated MapVC");
   
    
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
    
    //set maps center
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(30.30926, -97.723481);//only for emulator version, use userLocation in mobile version
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5f, 0.5f);
    MKCoordinateRegion region = MKCoordinateRegionMake (center, span);
    [_map setRegion:region];
    
    _quickSearchField.delegate = self;
 
    //create bar button for sidebar stuff
    UIBarButtonItem *leftMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Account"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(showLeftMenu:)];
    
    self.navigationItem.leftBarButtonItem = leftMenuButton;
    
    //set the nav bar icon image
    UIImage *logo = [UIImage imageNamed:@"truck-icon"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logo];
    
    
    //if user taps away from text field the app dismisses the keyboard
    
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.map addGestureRecognizer:tapBackground];
    

    //setdatasource and delegate for search results table
    [self.searchesTable setDelegate:self];
    [self.searchesTable setDataSource:self];


}

-(void) dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void) displayAlert:(NSString*) title message:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    AppDelegate* dele = [[UIApplication sharedApplication] delegate];
    TruckInfo* t = view.annotation;

    if ([dele.localFavoriteArray containsObject:t.dictForJSONConvert]) {
        
        [self displayAlert:@"You already have that truck in your favorites list!!" message:@"D'oh  X__X"];
        return;
    }
    
    
    NSLog(@"BEFORE ADD\n%@",dele.localFavoriteArray);
    [dele.localFavoriteArray addObject:t.dictForJSONConvert];
    [dele saveFavArrToParse];
    NSLog(@"AFTER ADD\n%@",dele.localFavoriteArray);
    
    [self displayAlert:@"Truck added to your favorites list" message:@"√ √ √"];
    

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>) annotation {
    
    if([annotation isEqual:[mapView userLocation]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"MKPinAnnotationView"];
    annotationView.canShowCallout = YES;
    
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [favButton addTarget:self
                     action:nil
           forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.rightCalloutAccessoryView = favButton;
    
    return annotationView;
}


- (void)showLeftMenu:(id)sender
{
    AppDelegate* dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(dele.sidebarVC.sidebarIsPresenting)
    {
        [dele.sidebarVC dismissSidebarViewController];
            }
    else
    {
        NSString* name = [PFUser currentUser].username;
        dele.leftVC.userLabel.text = [NSString stringWithFormat:@"Hi %@!",name];
        [dele.sidebarVC presentLeftSidebarViewController];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"enter pressed");
    if (textField.tag == 1) {
        [self yelp:_quickSearchField.text];
        [textField resignFirstResponder];
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
                BOOL categoryMatch = [self searchParam:searchParam inList:d[@"categories"]];

                if ([ d[@"id"] containsString:searchParam ] || categoryMatch) {
                    NSLog(@"%@\n\n", d);
                    [cutResults addObject:d];
                }
            }
            
            _searchesArray = cutResults;
            [searchesTable reloadData];

            [self dropPinOnAddress:cutResults];
            

            

        } else {
            NSLog(@"No business was found");
        }
        
        dispatch_group_leave(requestGroup);
    }];
    
    
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER); // This avoids the program exiting before all our asynchronous callbacks have been made.
    
}


- (BOOL) searchParam:(NSString*) searchParam inList:(NSDictionary*) dict {
 
    //NSLog(@"Looking for %@ in \n%@",searchParam,dict);
    
    for(NSArray* a in dict) {
        for (NSString* str in a) {
            if ([str caseInsensitiveCompare:searchParam] == NSOrderedSame) {
                //NSLog(@"%@ is equal to %@", str,searchParam);
                return YES;
            }
        }
    }
    
    return NO;
}

- (void) dropPinOnAddress:(NSMutableArray*) array {
    [self.map removeAnnotations:[self.map annotations]];
    
    
    for (NSDictionary* d in array) {

        NSDictionary * location = d[@"location"];
        NSString* name = d[@"id"];
        NSArray * addressParts = location[@"display_address"];
        NSString * address = [self appendFromArrayOfStrings:addressParts];

        NSString* imageURL = d[@"image_url"];
        NSString* mobileURL = d[@"mobile_url"];
        NSString* displayPhone = d[@"display_phone"];
                
        //NSLog(@"%@ is located at %@",name, address);

        TruckInfo* truckInfo = [[TruckInfo alloc] initWithTitle:name address:address imageURL:imageURL mobileURL:mobileURL displayPhone:displayPhone ];//places the annotation on the map due to geocoder asynchronously converting the address to coordinates. the addAnnotation call is done within the completion block of the geocoder
        
        
        //NSLog(@"name: %@\nlat: %f\nlon: %f",truckInfo.title, truckInfo.coordinate.latitude, truckInfo.coordinate.longitude);
       NSLog(@"name: %@\naddress: %@\nimageURL: %@\nmobileURL: %@\ndisplayPhone: %@",truckInfo.title, truckInfo.subtitle, truckInfo.imageURL, truckInfo.mobileURL,  truckInfo.displayPhone);

    }
    
    
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
        NSLog(@"not logged in");
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view.window endEditing: YES];

}

/*
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        NSLog(@"still logged in");
    }
    else {
        NSLog(@"logged out");
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
}
 */

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

/*
- (void)dealloc {
    [_quickSearchField release];
    [super dealloc];
}
 */
@end
