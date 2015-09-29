//
//  TruckInfo.m
//  Truckr
//
//  Created by Mac OS on 7/6/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//  Source 1. used to change address string to CLLocationCoordinate2D
//  http://stackoverflow.com/questions/9606031/ios-mkmapview-place-annotation-by-using-address-instead-of-lat-long


#import "TruckInfo.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"


@implementation TruckInfo

//have to have this as part of the protocol, but use the other init instead.
-(id) initWithTitle:(NSString*) newTitle coord:(CLLocationCoordinate2D) coord {
    self = [super init];
    if(self) {
        _title = newTitle;
        _coordinate = coord;
    }
    return self;
}

-(id) initWithTitle:(NSString *)newTitle address:(NSString* )address imageURL:(NSString*)imageURL mobileURL:(NSString*)mobileURL  displayPhone:(NSString*) displayPhone {
    
    self = [super init];
    if (self) {
        _title = newTitle;
        
        _title = [self cleanName:_title];
        
        _subtitle = address;
        _imageURL = imageURL;
        _mobileURL = mobileURL;
        _displayPhone = displayPhone;
        
        //add the necessary things to the dictionary. this dictionary will be used to store the truck information
        _dictForJSONConvert = [[NSMutableDictionary alloc] init];
        [_dictForJSONConvert setValue:_title forKey:@"truckTitle"];
        [_dictForJSONConvert setValue:_subtitle forKey:@"truckAddress"];
        [_dictForJSONConvert setValue:_imageURL forKey:@"imageURL"];
        [_dictForJSONConvert setValue:_mobileURL forKey:@"mobileURL"];
        [_dictForJSONConvert setValue:_displayPhone forKey:@"displayPhone"];
        
        
        [self addrToCoord:address];//sets the coordinate property
    }
    return self;
}

-(NSString*) cleanName: (NSString*) name {
    
    name = [name stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    name = [name capitalizedString];
    
    return name;
}


-(MKAnnotationView*) annotationView {
    MKAnnotationView * annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"TruckInfo"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

//source 1
-(void) addrToCoord:(NSString*) location {
    AppDelegate* dele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MapViewController* mvc = dele.mapVC;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         _coordinate = placemark.coordinate;
                         [mvc.map addAnnotation:self];
                     }
                     else {
                         NSString *errorString = [error userInfo][@"error"];
                         NSLog(@"%@", errorString);
                     }
                     [mvc.map showAnnotations:mvc.map.annotations animated:NO];

                 }
     ];
}






@end
