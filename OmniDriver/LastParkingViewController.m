//
//  ViewController.m
//  Parking
//
//  Created by Xinqian Li on 7/20/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "LastParkingViewController.h"
#import "EventAnnotation.h"
#import "DirectionViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>
#import "PNChart.h"
#import <AudioToolbox/AudioToolbox.h>
#import "VBFPopFlatButton.h"
#import "Social/Social.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "VBFPopFlatButton.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>
#import "PNChart.h"
#import "ChameleonFramework/Chameleon.h"
#import "VBFPopFlatButton.h"
#import "RESideMenu.h"


@interface LastParkingViewController ()
@property (nonatomic, strong) VBFPopFlatButton *leftButton;
@end

@implementation LastParkingViewController

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makebar];
    [self makeleftbutton];
    
    self.mapView.showsUserLocation = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    self.results = [[NSMutableArray alloc]init];
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    
    
    
    
    [self.view addSubview:self.mapView];
    float spanX = 0.008;
    float spanY = 0.008;
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(40.444663, -79.945039);
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    
    self.mapAnnotations = [[NSMutableArray alloc]init];
    [self.view addSubview: self.mapView];
    [self initConstraints];
    [self query];
    
    
    
}

-(void)addAllPins
{
    self.mapView.delegate=self;
    NSMutableArray *name=[[NSMutableArray alloc]init];
    NSMutableArray *add=[[NSMutableArray alloc]init];
    NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc]init];
    int i;
    [name addObject:@"Last parking location"];
    [arrCoordinateStr addObject:[NSString stringWithFormat:@"%@, %@",self.lat, self.longitude]];
    [add addObject:@""];
    for(int i = 0; i < name.count; i++)
    {
        [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i] Andadd: add[i]];
    }
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate Andadd:(NSString *)add
{
    MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
    
    // clear out any white space
    strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // convert string into actual latitude and longitude values
    NSArray *components = [strCoordinate componentsSeparatedByString:@","];
    
    double latitude = [components[0] doubleValue];
    double longitude = [components[1] doubleValue];
    
    // setup the map pin with all data and add to map view
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    mapPin.title = title;
    mapPin.subtitle = add;
    mapPin.coordinate = coordinate;
    
    
    [self.mapView addAnnotation:mapPin];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Disabled"
                                                                       message:@"Please enable location services in the Settings app."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Split view


#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass:[EventAnnotation class]])
    {
        annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        
        
        if (annotationView == nil)
        {
            
            annotationView.canShowCallout = YES;
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            if([annotation isKindOfClass:[MKUserLocation class]] )
            {
                MKAnnotationView* annotationView = [mapView viewForAnnotation:annotation];
                annotationView.canShowCallout = NO;
            }
            annotationView.animatesDrop = YES;
            annotationView.pinTintColor = [UIColor yellowColor];
            return annotationView;
        }
        else
        {   annotationView.animatesDrop = YES;
            annotationView.pinTintColor = [UIColor yellowColor];
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}
- (UIButton *)carButton {
    UIImage *image = [UIImage imageNamed:@"car.jpg"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30,30); // don't use auto layout
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    view.leftCalloutAccessoryView = [self carButton];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(calloutTapped:)];
    [view addGestureRecognizer:tapGesture];
    self.selectedCoordinate = view.annotation.coordinate;
    self.selectedPlace = view.annotation.title;
    
}

-(void)calloutTapped:(UITapGestureRecognizer *) sender
{
    
    
    MKAnnotationView *view = (MKAnnotationView*)sender.view;
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        DirectionViewController *dVC = [[DirectionViewController alloc]init];
        [self.navigationController pushViewController:dVC animated:YES];
        
        MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.selectedCoordinate.latitude, self.selectedCoordinate.longitude) addressDictionary:nil];
        NSLog(@"%@", placemark);
        [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
        [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
        directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;
        MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.description);
            } else {
                dVC.spanX = 0.8;
                dVC.spanY = 0.8;
                dVC.routeDetails  = response.routes.lastObject;
                
                [dVC.mapView addOverlay:[dVC.routeDetails polyline] level:MKOverlayLevelAboveRoads];
                
                dVC.destinationLabel.text = self.selectedPlace;
                dVC.distanceLabel.text = [NSString stringWithFormat:@"%0.1f Miles", dVC.routeDetails.distance/1609.344];
                dVC.transportLabel.text = @"Drive";
                dVC.allSteps = @"";
                for (int i = 0; i < dVC.routeDetails.steps.count; i++) {
                    MKRouteStep *step = [dVC.routeDetails.steps objectAtIndex:i];
                    NSString *newStep = step.instructions;
                    dVC.allSteps = [dVC.allSteps stringByAppendingString:newStep];
                    dVC.allSteps = [dVC.allSteps stringByAppendingString:@"\n\n"];
                    dVC.steps.text = dVC.allSteps;
                }
            }
        }];
    }
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *route = overlay;
        MKPolylineRenderer *routeRenderer = [[MKPolylineRenderer alloc] initWithPolyline:route];
        routeRenderer.strokeColor = [UIColor blueColor];
        return routeRenderer;
    }
    else return nil;
}

-(void)initConstraints
{
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    id views = @{
                 @"mapView": self.mapView
                 };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:views]];
}



- (void) query{
    
    NSString *link = @"http://ec2-52-90-207-217.compute-1.amazonaws.com/lastparking";
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:link];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            
                                                            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                            self.lat = [jsonResponse valueForKey:@"latitude"];
                                                            self.longitude = [jsonResponse valueForKey:@"longitude"];
                                                            
                                                            [self addAllPins];
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];
    
}

-(void) makebar{
    self.navigationController.navigationBar.barTintColor = [UIColor flatNavyBlueColorDark];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"LAST PARKING";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
}


-(void) makeleftbutton {
    self.leftButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    
    self.leftButton.lineThickness = 2;
    self.leftButton.linesColor = [UIColor whiteColor];
    [self.leftButton addTarget:self action:@selector(leftMenuButtonPressed:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

-(void)leftMenuButtonPressed:(VBFPopFlatButton *)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
