//
//  DirectionViewController.m
//  OmniDriver
//
//  Created by Li Fang  on 7/28/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//


#import "DirectionViewController.h"

@interface DirectionViewController ()

@end

@implementation DirectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.mapView.delegate =self;
    self.spanX=0.08;
    self.spanY=0.08;
    MKCoordinateRegion region;
    region.center = CLLocationCoordinate2DMake(40.444663, -79.945039);
    region.span = MKCoordinateSpanMake(self.spanX, self.spanY);
    [self.mapView setRegion:region animated:YES];
    
    [self.view addSubview:self.mapView];
    
    UILabel *des = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, 100, 20)];
    des.text = @"Destination:";
    
    [self.view addSubview: des];
    self.destinationLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 380, self.view.frame.size.width, 20)];
    [self.view addSubview:self.destinationLabel];
    UILabel *dis = [[UILabel alloc]initWithFrame:CGRectMake(10, 400, 100, 20)];
    [self.view addSubview: dis];
    dis.text = @"Distance:";
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 400, self.view.frame.size.width, 20)];
    [self.view addSubview:self.distanceLabel];
    UILabel *trans = [[UILabel alloc]initWithFrame:CGRectMake(10, 420, 100, 20)];
    [self.view addSubview: trans];
    trans.text = @"Transport:";
    self.transportLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 420, self.view.frame.size.width, 20)];
    [self.view addSubview:self.transportLabel];
    
    UILabel *steps = [[UILabel alloc]initWithFrame:CGRectMake(10, 440, 100, 20)];
    [self.view addSubview: steps];
    steps.text = @"Steps:";
    self.steps= [[UITextView alloc]initWithFrame:CGRectMake(100, 440, 250, 200)];
    [self.steps flashScrollIndicators];
    [self.steps isScrollEnabled];
    self.steps.showsVerticalScrollIndicator=YES;
    [self.view addSubview:self.steps];
    
    
    
    // Do any additional setup after loading the view.
}
//-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
//    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:self.routeDetails.polyline];
//    routeLineRenderer.strokeColor = [UIColor redColor];
//    routeLineRenderer.lineWidth = 5;
//    return routeLineRenderer;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
