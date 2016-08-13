//
//  Statistic.m
//  OmniDriver
//
//  Created by Li Fang  on 7/30/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import "StatisticViewController.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>
#import "PNChart.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"
#import "EFloatBox.h"
#import "EColor.h"
#include <stdlib.h>
#import "PNChart.h"
#import "ChameleonFramework/Chameleon.h"
#import "VBFPopFlatButton.h"
#import "RESideMenu.h"
#import "Social/Social.h"
@interface StatisticViewController ()
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) VBFPopFlatButton *leftButton;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makerightbutton];
    [self makebar];
    [self makeleftbutton];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"Score",@"Efficiency", @"Distance"]];
    self.typeString = @"Score";
    self.timeString = @"weekly";
    self.upperBound = 100;
    [segmentControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl.frame = CGRectMake(-10, 60, self.view.frame.size.width+20, 50);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl setBackgroundColor:[UIColor whiteColor]];
    [segmentControl setTintColor:[UIColor colorWithRed:(192/255.0) green:(192/255.0) blue:(192/255.0) alpha:1]];
    
    [self.view addSubview:segmentControl];
    self.xLabels = @[@"SUN",@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    UIColor *myBlueColor = [UIColor colorWithRed:(175/255.0) green:(216/255.0) blue:(238/255.0) alpha:1];
    [self generateChart:myBlueColor :100];
    
    self.bgview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 110.0f, 500.0f, 200.0f)];
    self.bgview.backgroundColor =  myBlueColor;
    [self.view addSubview:self.bgview];
    
    UISegmentedControl *segmentControl2 = [[UISegmentedControl alloc]initWithItems:@[@"weekly",@"monthly", @"yearly"]];
    
    [segmentControl2 setSegmentedControlStyle:UISegmentedControlStyleBar];
    segmentControl2.frame = CGRectMake(30, 580, 320, 30);
    [segmentControl2 addTarget:self action:@selector(segmentedControlValueDidChange2:) forControlEvents:UIControlEventValueChanged];
    [segmentControl2 setSelectedSegmentIndex:0];
    [segmentControl2 setBackgroundColor:[UIColor whiteColor]];
    [segmentControl2 setTintColor:[UIColor grayColor]];
    [self.view addSubview:segmentControl2];
    self.xLabels = @[@"SUN",@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    self.instructLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 150, 350, 30)];
    self.instructLabel.text = @"Score, weekly average";
    [self.instructLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.instructLabel];
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 180, 200, 80)];
    
    self.scoreLabel.text = @"80";
    self.scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:76];
    [self.view addSubview:self.scoreLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            
            self.typeString = @"Score";
            self.instructLabel.text = [NSString stringWithFormat:@"%@%@ average",@"Score, ", self.timeString];
            UIColor *myBlueColor = [UIColor colorWithRed:(175/255.0) green:(216/255.0) blue:(238/255.0) alpha:1];
            self.curColor = myBlueColor;
            [self generateChart:myBlueColor :100];
            self.scoreLabel.text=@"80";
            self.bgview.backgroundColor =  myBlueColor;

            break;
        }
        case 1:{
            
            self.typeString = @"Efficiency";
             self.scoreLabel.text=@"70";
            self.instructLabel.text = [NSString stringWithFormat:@"%@%@ average",@"Efficiency, ", self.timeString];
            UIColor *myGreenColor = [UIColor colorWithRed:(166/255.0) green:(224/255.0) blue:(165/255.0) alpha:1];
            [self generateChart: myGreenColor :50];
            self.curColor = myGreenColor;
           
            self.bgview.backgroundColor =  myGreenColor;
            break;
        }
        case 2:{
            
            self.typeString = @"Kilometer";
            self.instructLabel.text = [NSString stringWithFormat:@"%@%@ average",@"Kilometer, ", self.timeString];
            self.scoreLabel.text=@"90";
            UIColor *myMintColor = [UIColor colorWithRed:(198/255.0) green:(237/255.0) blue:(232/255.0) alpha:1];
            self.curColor = myMintColor;
            [self generateChart: myMintColor :50];
            self.bgview.backgroundColor =  myMintColor;

            
            break;
        }
    }
}
-(void)segmentedControlValueDidChange2:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            
            self.timeString = @"weekly";
            self.xLabels = @[@"SUN",@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
            self.instructLabel.text = [NSString stringWithFormat:@"%@, %@ average",self.typeString, self.timeString];
            [self generateChart:self.curColor :100];
            break;
        }
        case 1:{
            
            self.timeString = @"monthly";
           self.xLabels = @[@"JAN",@"FEB", @"MAR", @"APR", @"MAY", @"JUN", @"JUL"];
            self.instructLabel.text = [NSString stringWithFormat:@"%@, %@ average",self.typeString, self.timeString];
            [self generateChart: self.curColor :50];
            
            break;
        }
        case 2:{
            self.xLabels = @[@"2010",@"2011", @"2012", @"2013", @"2014", @"2015", @"2016"];
            
            self.timeString = @"yearly";
            self.instructLabel.text = [NSString stringWithFormat:@"%@, %@ average",self.typeString, self.timeString];
            [self generateChart:self.curColor :30];
            break;
        }
    }
}

-(void) generateChart: (UIColor *) color : (int) upperbound{
    [self.lineChart removeFromSuperview];
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(10, 350.0, self.view.frame.size.width, 200.0)];
    [self.lineChart setXLabels:self.xLabels];
    self.lineChart.tintColor=color;            // Line Chart No.1
    
    self.data01Array =[NSMutableArray array];
    for (int i = 0; i < self.xLabels.count; i++)
    {
        NSNumber *value = [NSNumber numberWithInt: (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * upperbound) + 1];
        
        [self.data01Array addObject:value];
    }
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = color;
    data01.itemCount = self.lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [self.data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    self.lineChart.chartData = @[data01];
    [self.lineChart strokeChart];
    [self.view addSubview:self.lineChart];
    
}
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
-(void) makerightbutton {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"twitter-icon.png"] forState:UIControlStateNormal];
    rightButton.contentMode = UIViewContentModeScaleAspectFill;
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(sendtwitter:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

-(void) sendtwitter: (UIButton *) sender{
    
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ %@",self.instructLabel.text,self.scoreLabel.text]];
        
        
        [tweetSheet addImage:[self imageWithView:self.lineChart]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    //[self readTweets:self];
    
}
-(void) makebar{
    self.navigationController.navigationBar.barTintColor = [UIColor flatNavyBlueColorDark];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"STATISTICS";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
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

