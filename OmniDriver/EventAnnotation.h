//
//  EventAnnotation.h
//  OmniDriver
//
//  Created by Li Fang  on 7/28/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface EventAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, retain) NSString *detailAddr;


@end