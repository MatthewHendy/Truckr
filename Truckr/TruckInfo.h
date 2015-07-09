//
//  TruckInfo.h
//  Truckr
//
//  Created by Mac OS on 7/6/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface TruckInfo : MKMapItem <MKAnnotation>

@property (copy, nonatomic) NSString* title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) MKPlacemark* pl;
@property (copy, nonatomic) NSString* subtitle;
//@property (copy, nonatomic) NSString* description;

-(id) initWithTitle:(NSString*) newTitle coord:(CLLocationCoordinate2D) coord;
-(id) initWithTitle:(NSString *)newTitle address:(NSString* )address;

-(MKAnnotationView*) annotationView;


@end
