//
//  Statistic.h
//  OmniDriver
//
//  Created by Li Fang  on 7/30/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "EPieChart.h"
#import "PNChart.h"
@interface StatisticViewController : UIViewController
@property (nonatomic,strong) PNLineChart * lineChart;
@property (nonatomic,strong) NSArray *xLabels;
@property (nonatomic,strong) NSMutableArray *data01Array;
@property NSString *typeString;
@property NSString *timeString;
@property UIColor *curColor;
@property UIView *bgview;
@property int upperBound;
@property UILabel *instructLabel;
@property UILabel *scoreLabel;
@end
