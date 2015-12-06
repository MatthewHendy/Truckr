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


@end


static NSString * searchLocation = @"Austin, TX";

@implementation MapViewController

@synthesize searchesTable;


//Table View code
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"numRows is %d",[_searchesArray count] );
    return [_searchesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
    
    //NSLog(@"here in cellForRow %d\nname: %@\naddress: %@\n\n",[_searchesArray count],name, address);
    //NSLog(@"here in cellForRow 2\nname: %@\naddress: %@\n\n",cell.textLabel.text, cell.detailTextLabel.text);

    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Clicked");
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //NSLog(@"did update to locations %@", locations[0]);
    CLLocation *location = locations[0];
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
    
    if (location != nil) {        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
            MKPlacemark* placemark = placemarks[0];
            //NSLog(@"%@\n\n\n", placemark);
            
            NSString *city = placemark.locality;
            NSString *state = placemark.addressDictionary[@"State"];
            NSString* newCityAndState = [[city stringByAppendingString:@", "] stringByAppendingString:state];
            
            NSLog(@"%@\n\n\n\n",newCityAndState);
            
            searchLocation = newCityAndState;
        }];
        
    }
    
    
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
    
    
    NSLog(@"latitudeerinos: %f\nlongituderinos: %f",_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);

    //set map properties for once i get the user location working. i think its the emulator issue
    _map.delegate = self;
    [_map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];    
    [_map setCenterCoordinate:_map.userLocation.location.coordinate animated:YES];
    
    
    //set maps center. hard coded in because for some reason i can't get the coordinates from the user location
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_latitude, _longitude);//only for emulator version, use userLocation in mobile version
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
    UIImage *logo = [UIImage imageNamed:@"finaltruckriconclear"];
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
    
    TruckInfo* t = view.annotation;

    if (control.tag == 0) {
        NSLog(@"AADDDING TO FAVORITES\n\n\n\n");
        AppDelegate* dele = [[UIApplication sharedApplication] delegate];

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
    else {
        NSLog(@"SEGUING ");
        [self performSegueWithIdentifier:@"showTruckVC" sender:t];
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>) annotation {
    
    if([annotation isEqual:[mapView userLocation]]) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"MKPinAnnotationView"];
    annotationView.canShowCallout = YES;
    
    //add favorites button
    UIButton *favButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [favButton addTarget:self
                     action:nil
           forControlEvents:UIControlEventTouchUpInside];
    //add tag to zero to differentiate from the info button.
    favButton.tag = 0;
    annotationView.rightCalloutAccessoryView = favButton;

    //add segue to info screen button
    UIButton *infoSegue = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [favButton addTarget:self
                  action:nil
        forControlEvents:UIControlEventTouchUpInside];
    //make tag 1
    infoSegue.tag = 1;
    annotationView.leftCalloutAccessoryView = infoSegue;
    
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
    
    BOOL b = [self testInternetConnection];
    
    if (!b) {
        NSLog(@"Connection failed");
        return NO;
    }
    
    
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
            [self displayAlert:@"An error happened during the request" message:[NSString stringWithFormat:@"%@",error]];
        }
        
        else if (resultsJSON) {
            
            //this array will have the JSON's that have id's that contain the original user entered search term this trims down the returned trucks to ones that the user wants
            NSMutableArray* cutResults = [[NSMutableArray alloc] init];
            
            for(NSDictionary* d in resultsJSON) {
                BOOL categoryMatch = [self searchParam:searchParam inList:d[@"categories"]];
                //NSLog(@"1");
                //NSLog(@"%@",d);
                //NSLog(@"2");
                if ([ d[@"id"] containsString:searchParam ] || categoryMatch) {
                    //NSLog(@"%@\n\n", d);
                    [cutResults addObject:d];
                }
                
            }
            
            //if the filtered search has nothing left then display appropriate message
            if ([cutResults count] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^ {
                    [[[UIAlertView alloc] initWithTitle:@"There were no trucks with that name"
                                                message:nil
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil
                      ] show];
                });
            }
            
            _searchesArray = cutResults;
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [searchesTable reloadData];
            });
            [self dropPinOnAddress:cutResults];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [[[UIAlertView alloc] initWithTitle:@"There were no trucks with that name"
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil
                  ] show];
            });
            //[self displayAlert:@"No business was found" message:@"Try another search"];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    NSLog(@"SHOWTRUCK\n\n");
    if ([[segue identifier] isEqualToString:@"showTruckVC"]) {
        
        
        if ([sender isKindOfClass:[TruckInfo class]]) {
            NSLog(@"hey its segueing from the map annotation\n\n\n\n\n\n");
            TruckViewController *vc = (TruckViewController *) [segue destinationViewController];
            TruckInfo *info = (TruckInfo *) sender;
            
            vc.nameText = info.title;
            vc.addressText = info.subtitle;
            vc.phoneText = info.displayPhone;
            vc.mobileURLText = info.mobileURL;
            vc.imageURLText = info.imageURL;
        }
        
        else {
            
            NSLog(@"hey its seging from the cell\n\n\n\n\n\n");
            NSIndexPath *indexPath = [self.searchesTable indexPathForCell:sender];

            TruckViewController *vc = (TruckViewController *) [segue destinationViewController];
            searchesTableCell *cell = (searchesTableCell*) [self.searchesTable cellForRowAtIndexPath:indexPath];
        
            vc.nameText = cell.cellTitle.text;
            vc.addressText = cell.cellAddress.text;
            vc.phoneText = cell.displayPhone;
            vc.mobileURLText = cell.mobileURL;
            vc.imageURLText = cell.imageURL;
        
            /*vc.imageView.image = [UIImage imageWithData:
             [NSData dataWithContentsOfURL:
             [NSURL URLWithString: image]]];*/
        
            NSLog(@"in favTable\nnameLabel: %@\nadressLabel: %@\nphoneLabel: %@\nmobileLabel: %@",vc.nameText,vc.addressText,vc.phoneText,vc.mobileURLText);
        }
        
        
    }
    
}


// Checks if we have an internet connection or not
- (BOOL)testInternetConnection
{
    Reachability *internetReachableFoo;

    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    
    if (internetReachableFoo.isReachable) {
        NSLog(@"INTERNET!!!\n\n\n\n\n");
        return 1;
    }
    
    else {
        [self displayAlert:@"No internet connection" message:@":("];
        return 0;
    }
    
    
    [internetReachableFoo startNotifier];
    return 1;
    
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
