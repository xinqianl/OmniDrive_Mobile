//
//  LastParking.h
//  OmniDriver
//
//  Created by Li Fang  on 8/1/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EventAnnotation.h"
@interface LastParkingViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property NSArray *locs;
@property NSString *lat;
@property NSString *longitude;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property CLLocationCoordinate2D selectedCoordinate;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) MKPlacemark *result;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSArray *searchPlacemarksCache;
@property (nonatomic, strong) NSArray *mapItemList;
@property (nonatomic, strong) NSString *input;
@property (nonatomic, strong) NSString *selectedPlace;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSString *coordString;
@property (assign, nonatomic) MKCoordinateRegion *region;
@property (assign, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) CLLocation *location;

@end

