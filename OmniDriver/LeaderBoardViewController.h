//
//  LeaderScore.h
//  OmniDriver
//
//  Created by Li Fang  on 7/28/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "EPieChart.h"
@interface LeaderBoardViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *nums;
@property UIView *bgview;
@property NSString *selectedTitle;
@end
