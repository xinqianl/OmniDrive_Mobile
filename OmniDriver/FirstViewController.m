//
//  ContentViewController.m
//  OmniDriver
//
//  Created by Li Fang  on 7/21/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//
#import "FirstViewController.h"
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
#import <AVFoundation/AVFoundation.h>
@interface FirstViewController () <CBCentralManagerDelegate,CBPeripheralDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) VBFPopFlatButton *leftButton;
@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

// this is bluetooth
@property (strong, nonatomic) CBCentralManager *centralManger;
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (strong,nonatomic) NSMutableArray *peripherals;
@end

@implementation FirstViewController
@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;
@synthesize eColumnChart = _eColumnChart;
@synthesize data = _data;
@synthesize eColumnSelected = _eColumnSelected;
@synthesize valueLabel = _valueLabel;
@synthesize ePieChart = _ePieChart;
@synthesize ePieChart2 = _ePieChart2;
@synthesize ePieChart3 = _ePieChart3;
@synthesize circleChart = _circleChart;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.peripherals = [NSMutableArray new];
    
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self
                                                              queue:nil
                                                            options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}
                          ];
    [self makebar];
    [self makeleftbutton];
    [self makerightbutton];
    self.idNum = 40;
    
    self.dictionary = [[NSMutableDictionary alloc]init];
    UIColor *myBlueColor = [UIColor colorWithRed:(12/255.0) green:(90/255.0) blue:(172/255.0) alpha:1];
    UIColor *myYellowColor = [UIColor colorWithRed:(253/255.0) green:(223/255.0) blue:(51/255.0) alpha:1];
    UIColor *myLightBlue = [UIColor colorWithRed:(104/255.0) green:(151/255.0) blue:(187/255.0) alpha:1];
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 270.0f, 500.0f, 800.0f)];
    view.backgroundColor =  myBlueColor;
    [self.view addSubview:view];
    
    _circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 100.0, SCREEN_WIDTH, 130.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:self.scoreNum] clockwise:YES shadow:YES shadowColor: [UIColor whiteColor]];
    _circleChart.backgroundColor = [UIColor whiteColor];
    [_circleChart setStrokeColor:myBlueColor];
    [_circleChart strokeChart];
    [self.view addSubview:_circleChart];
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(128, 200.0, SCREEN_WIDTH/2, 100.0)];
    scoreLabel.text = @"Realtime Score";
    scoreLabel.textColor = myBlueColor;
    scoreLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.view addSubview:scoreLabel];
    
    self.mileNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 90.0, SCREEN_WIDTH/2, 20.0)];
    self.mileNumLabel.text = @"0";
    [self.view addSubview:self.mileNumLabel];
    
    self.mileLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 110.0, SCREEN_WIDTH/2, 20.0)];
    self.mileLabel.text = @"MILES";
    self.mileLabel.textColor = myLightBlue;
    self.mileLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.view addSubview:self.mileLabel];
    
    self.fuelNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 90.0, SCREEN_WIDTH/2, 20.0)];
    self.fuelNumLabel.text = @"0";
    [self.view addSubview:self.fuelNumLabel];
    
    self.fuelLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 110.0, SCREEN_WIDTH/2, 20.0)];
    self.fuelLabel.text = @"GALLON";
    self.fuelLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.fuelLabel.textColor = myLightBlue;
    [self.view addSubview:self.fuelLabel];
    
    self.timeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 180.0, SCREEN_WIDTH/2, 20.0)];
    self.timeNumLabel.text = @"0m0s";
    [self.view addSubview:self.timeNumLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 200.0, SCREEN_WIDTH/2, 20.0)];
    self.timeLabel.text = @"Time";
    self.timeLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.timeLabel.textColor = myLightBlue;
    [self.view addSubview:self.timeLabel];
    
    self.speedNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 180.0, SCREEN_WIDTH/2, 20.0)];
    self.speedNumLabel.text = @"0";
    [self.view addSubview:self.speedNumLabel];
    
    self.speedLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 200.0, SCREEN_WIDTH/2, 20.0)];
    self.speedLabel.text = @"MPH";
    self.speedLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.speedLabel.textColor = myLightBlue;
    [self.view addSubview:self.speedLabel];
    
    UILabel *dailyStatLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 280.0, SCREEN_WIDTH/2, 20.0)];
    dailyStatLabel.text = @"Daily Stats";
    dailyStatLabel.textColor = myLightBlue;
    dailyStatLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [self.view addSubview:dailyStatLabel];
    NSMutableArray *temp = [NSMutableArray array];
    NSArray *weekdays = @[@"SUN",@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT"];
    for (int i = 0; i < 7; i++)
    {
        int value = (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * 90) + 1;
        NSString *day = [weekdays objectAtIndex:i];
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:day value:value index:i unit:@""];
        [temp addObject:eColumnDataModel];
    }
    _data = [NSArray arrayWithArray:temp];
    
    
    _eColumnChart = [[EColumnChart alloc] initWithFrame:CGRectMake(50, 320.0, 300, 130.0)];
    [_eColumnChart setColumnsIndexStartFromLeft:YES];
    [_eColumnChart setDelegate:self];
    [_eColumnChart setDataSource:self];
    _eColumnChart.barColor = myYellowColor;
    
    
    [self.view addSubview:_eColumnChart];
    
    
    EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:10 current:self.brakeNum estimate:0];
    
    if (!_ePieChart)
    {
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(20, 500, 100, 100)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    [_ePieChart setDelegate:self];
    [_ePieChart setDataSource:self];
    _ePieChart.frontPie.title.text = @"0";
    [self.view addSubview:_ePieChart];
    
    
    EPieChartDataModel *ePieChartDataModel2 = [[EPieChartDataModel alloc] initWithBudget:10 current:self.overSpeedNum estimate:0];
    _ePieChart2 = [[EPieChart alloc] initWithFrame:CGRectMake(140, 500, 100, 100)
                                ePieChartDataModel:ePieChartDataModel2];
    [_ePieChart2 setDelegate:self];
    [_ePieChart2 setDataSource:self];
    _ePieChart2.frontPie.title.text = @"0";
    
    [self.view addSubview:_ePieChart2];
    
    EPieChartDataModel *ePieChartDataModel3 = [[EPieChartDataModel alloc] initWithBudget:10 current:self.accelNum estimate:0];
    _ePieChart3 = [[EPieChart alloc] initWithFrame:CGRectMake(260, 500, 100, 100)
                                ePieChartDataModel:ePieChartDataModel3];
    [_ePieChart3 setDelegate:self];
    [_ePieChart3 setDataSource:self];
    _ePieChart3.frontPie.title.text = @"0";
    [self.view addSubview:_ePieChart3];
    
    UILabel *brakeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 570, 100, 100)];
    brakeLabel.text = @"Hard brake #/h";
    brakeLabel.numberOfLines = 2;
    brakeLabel.textColor = [UIColor whiteColor];
    brakeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:brakeLabel];
    
    UILabel *brakeLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(140, 570, 100, 100)];
    brakeLabel2.text = @"Over 70 MPH #/h";
    brakeLabel2.numberOfLines = 2;
    brakeLabel2.textColor = [UIColor whiteColor];
    brakeLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:brakeLabel2];
    
    UILabel *brakeLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(260, 570, 100, 100)];
    brakeLabel3.text = @"Hard accel #/h";
    brakeLabel3.numberOfLines = 2;
    brakeLabel3.textColor = [UIColor whiteColor];
    brakeLabel3.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:brakeLabel3];
    
    [self performBackgroundTask];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
}

#pragma -mark- EColumnChartDataSource

- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return 7;
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

- (UIColor *)colorForEColumn:(EColumn *)eColumn
{
    if (eColumn.eColumnDataModel.index < 5)
    {
        return [UIColor purpleColor];
    }
    else
    {
        return [UIColor redColor];
    }
    
}

- (void)performBackgroundTask
{
    dispatch_queue_t serverDelaySimulationThread = dispatch_queue_create("com.xxx.serverDelay", nil);
    dispatch_async(serverDelaySimulationThread, ^{
        while (true) {
            
            [NSThread sleepForTimeInterval:1.0];
            [self query];
            dispatch_async(dispatch_get_main_queue(), ^{
                
            }
                           );
        }
    });
    
}
- (void) query{
    
    NSString *link = @"http://ec2-52-90-207-217.compute-1.amazonaws.com/status?id=";
    NSString *urlString = [link stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)self.idNum]];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithURL:url
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if(error == nil)
                                                        {
                                                            
                                                            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                            
                                                            NSString *minString = [jsonResponse valueForKey:@"min"];
                                                            NSString *secString = [jsonResponse valueForKey:@"sec"];
                                                            
                                                            
                                                            if([minString intValue]==3 && [secString intValue]==1){
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"ATTENTION: Drive over 1 min" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//                                                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                                                                AudioServicesPlaySystemSound(1110);

                                                                AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
                                                                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Attention, fatigue driving"];
                                                                [utterance setRate:0.5f];
                                                                [synthesizer speakUtterance:utterance];[alert show];
                                                                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
                                                            }
                                                            if(self.brakeNum!=[[jsonResponse valueForKey:@"brake"] integerValue]){
                                                                
                                                                [_ePieChart removeFromSuperview];
                                                                _ePieChart=nil;
                                                                self.brakeNum=[[jsonResponse valueForKey:@"brake"] integerValue];
                                                                EPieChartDataModel *ePieChartDataModel = [[EPieChartDataModel alloc] initWithBudget:10 current:self.brakeNum estimate:0];
                                                                _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(20, 500, 100, 100)
                                                                                           ePieChartDataModel:ePieChartDataModel];
                                                                _ePieChart.frontPie.title.text =[jsonResponse valueForKey:@"brake"];
                                                                [_ePieChart setDelegate:self];
                                                                [_ePieChart setDataSource:self];
                                                                [self.view addSubview:_ePieChart];
                                                            }
                                                            _ePieChart.frontPie.title.text =[jsonResponse valueForKey:@"brake"];
                                                            self.brakeNum =[[jsonResponse valueForKey:@"brake"]integerValue];
                                                            
                                                            if(self.overSpeedNum!=[[jsonResponse valueForKey:@"speedcount"] integerValue]){
                                                                
                                                                [_ePieChart2 removeFromSuperview];
                                                                _ePieChart2=nil;
                                                                self.overSpeedNum=[[jsonResponse valueForKey:@"speedcount"] integerValue];
                                                                EPieChartDataModel *ePieChartDataModel2 = [[EPieChartDataModel alloc] initWithBudget:10 current:self.overSpeedNum estimate:0];
                                                                _ePieChart2 = [[EPieChart alloc] initWithFrame:CGRectMake(140, 500, 100, 100)
                                                                                            ePieChartDataModel:ePieChartDataModel2];
                                                                _ePieChart2.frontPie.title.text =[jsonResponse valueForKey:@"speedcount"];
                                                                [_ePieChart2 setDelegate:self];
                                                                [_ePieChart2 setDataSource:self];
                                                                [self.view addSubview:_ePieChart2];
                                                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"ATTENTION: OVER 70 MPH" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
//                                                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//                                                                AudioServicesPlaySystemSound(1110);
                                                                AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
                                                                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Slow down, driving over 70"];
                                                                [utterance setRate:0.5f];
                                                                [synthesizer speakUtterance:utterance];[alert show];
                                                                [alert show];
                                                                [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1.0f];
                                                                
                                                            }
                                                            if(self.scoreNum!=[[jsonResponse valueForKey:@"score"] integerValue]){
                                                                self.scoreNum=[[jsonResponse valueForKey:@"score"] intValue];
                                                                [_circleChart removeFromSuperview];
                                                                _circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 100.0, SCREEN_WIDTH, 130.0) total:[NSNumber numberWithInt:100] current:[NSNumber numberWithInt:self.scoreNum] clockwise:YES shadow:YES shadowColor: [UIColor whiteColor]];
                                                                _circleChart.backgroundColor = [UIColor whiteColor];
                                                                UIColor *myBlueColor = [UIColor colorWithRed:(12/255.0) green:(90/255.0) blue:(172/255.0) alpha:1];
                                                                [_circleChart setStrokeColor:myBlueColor];
                                                                [_circleChart strokeChart];
                                                                [self.view addSubview:_circleChart];
                                                                
                                                            }
                                                            if(self.accelNum!=[[jsonResponse valueForKey:@"accelespeedcount"] integerValue]){
                                                                
                                                                [_ePieChart3 removeFromSuperview];
                                                                _ePieChart3=nil;
                                                                self.accelNum=[[jsonResponse valueForKey:@"accelespeedcount"] integerValue];
                                                                EPieChartDataModel *ePieChartDataModel3 = [[EPieChartDataModel alloc] initWithBudget:10 current:self.accelNum estimate:0];
                                                                _ePieChart3 = [[EPieChart alloc] initWithFrame:CGRectMake(260, 500, 100, 100)
                                                                                            ePieChartDataModel:ePieChartDataModel3];
                                                                _ePieChart3.frontPie.title.text =[jsonResponse valueForKey:@"accelespeedcount"];
                                                                [_ePieChart3 setDelegate:self];
                                                                [_ePieChart3 setDataSource:self];
                                                                [self.view addSubview:_ePieChart3];
                                                            }
                                                            self.idNum = self.idNum+1;
                                                            self.timeNumLabel.text = [NSString stringWithFormat:@"%@m%@s", minString, secString];
                                                            self.speedNumLabel.text = [jsonResponse valueForKey:@"avgspeed"];
                                                            self.mileNumLabel.text = [jsonResponse valueForKey:@"odometer"];
                                                            self.fuelNumLabel.text = [jsonResponse valueForKey:@"fuelconsumed"];
                                                            [self.timeNumLabel removeFromSuperview];
                                                            [self.view addSubview:self.timeNumLabel];
                                                            [self.speedNumLabel removeFromSuperview];
                                                            [self.view addSubview:self.speedNumLabel];
                                                            [self.mileNumLabel removeFromSuperview];
                                                            [self.view addSubview:self.mileNumLabel];
                                                            [self.fuelNumLabel removeFromSuperview];
                                                            [self.view addSubview:self.fuelNumLabel];
                                                            
                                                            [self.timeLabel removeFromSuperview];
                                                            [self.view addSubview:self.timeLabel];
                                                            [self.speedLabel removeFromSuperview];
                                                            [self.view addSubview:self.speedLabel];
                                                            [self.mileLabel removeFromSuperview];
                                                            [self.view addSubview:self.mileLabel];
                                                            [self.fuelLabel removeFromSuperview];
                                                            [self.view addSubview:self.fuelLabel];
                                                        }
                                                        
                                                    }];
    
    [dataTask resume];
}
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:nil animated:YES];
}

-(void) makebar{
    self.navigationController.navigationBar.barTintColor = [UIColor flatNavyBlueColorDark];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 84)];
    titleLabel.text = @"O M N I ";
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

-(void) makerightbutton {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"blueTooth"] forState:UIControlStateNormal];
    rightButton.contentMode = UIViewContentModeScaleAspectFill;
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton addTarget:self action:@selector(BlueToothButtonPressed:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)BlueToothButtonPressed:(UIButton *)sender
{
    if (!isConncted || !blueToothPoweredOn) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You can't connect to Bluetooth now, make sure you turn on the bluetooth and there is device nearby" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:
                                        ^(UIAlertAction *action) {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]];
                                        }
                                        ];
        
        [alertController addAction:settingAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        
        NSString *string = [NSString stringWithFormat: @"You have connected to the device, UUID is %@", UUIDFound];
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Congratulations"
                                  message:string
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

// bluetooth is on or not
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManger scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(NO)}];
        blueToothPoweredOn = true;
        needToBeConnected = true;
        
        
    }else{
        blueToothPoweredOn = false;
        NSLog(@">>>设备不支持BLE或者未打开");
    }
}

// discover devices
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    //    peripheral.delegate=self;
    //    self.peripheral=peripheral;
    //    [self.centralManger connectPeripheral:self.peripheral options:nil];
    if ([self.peripherals count] == 0) {
        [self.peripherals addObject:peripheral];
        [central connectPeripheral:peripheral options:nil];
    }
}

//是否连接成功
- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{   if (needToBeConnected) {
    UUIDFound = [peripheral.identifier UUIDString];
    [peripheral discoverServices:nil];
    needToBeConnected = false;
    isConncted = true;
}
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral");
}

@end
