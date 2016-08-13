//
//  ContentViewController.h
//  OmniDriver
//
//  Created by Li Fang  on 7/21/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//
#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "EPieChart.h"
#import "PNChart.h"
@interface FirstViewController : UIViewController<EColumnChartDelegate, EColumnChartDataSource, NSURLConnectionDelegate> {
    Boolean *blueToothPoweredOn;
    Boolean *needToBeConnected;
    Boolean *isConncted;
    NSString *UUIDFound;
}
@property (strong, nonatomic) EColumnChart *eColumnChart;

@property (weak, nonatomic)  UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIButton *turnPageButton;
@property (strong, nonatomic) EPieChart *ePieChart;
@property (strong, nonatomic) EPieChart *ePieChart2;
@property (strong, nonatomic) EPieChart *ePieChart3;
@property (strong, nonatomic) PNCircleChart *circleChart;
@property(strong, nonatomic) NSMutableDictionary *dictionary;
@property(strong, nonatomic) NSMutableData *responseData;
@property(strong, nonatomic) NSNotificationCenter *notification;
@property(strong, nonatomic) NSTimer *notificationTimer;
@property(strong, nonatomic) UILabel *mileNumLabel;
@property(strong, nonatomic) UILabel *mileLabel;
@property(strong, nonatomic) UILabel *fuelNumLabel;
@property(strong, nonatomic) UILabel *fuelLabel;
@property(strong, nonatomic) UILabel *timeNumLabel;
@property(strong, nonatomic) UILabel *timeLabel;
@property(strong, nonatomic) UILabel *speedNumLabel;
@property(strong, nonatomic) UILabel *speedLabel;
@property (nonatomic, assign) NSInteger idNum;
@property (nonatomic, assign) double brakeNum;
@property (nonatomic, assign) double overSpeedNum;
@property (nonatomic, assign) double accelNum;
@property (nonatomic, assign) int scoreNum;
//@property (nonatomic, assign) PNCircleChart *circleChart;
@end

