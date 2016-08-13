//
//  DirectionViewController.h
//  OmniDriver
//
//  Created by Li Fang  on 7/28/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DirectionViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic)  MKMapView *mapView;
@property (strong, nonatomic)  UILabel *destinationLabel;
@property (strong, nonatomic)  UILabel *distanceLabel;
@property (strong, nonatomic)  UILabel *transportLabel;
@property (strong, nonatomic)  UITextView *steps;

@property float spanX;
@property float spanY;

@property (strong, nonatomic) NSString *allSteps;
@property (strong, nonatomic) CLPlacemark *thePlacemark;
@property (strong, nonatomic) MKRoute *routeDetails;
@end
