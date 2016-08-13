//
//  ViewController.m
//  OmniDriver
//
//  Created by Li Fang  on 7/24/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManger;
//@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong,nonatomic) CBPeripheral *peripheral;
@property (nonatomic, strong) VBFPopFlatButton *leftButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self
                                                              queue:nil];
    // to add left button
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barTintColor = [UIColor flatNavyBlueColorDark];
    //self.navigationItem.title = @"O M N I1111";
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"O M N I22";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    self.leftButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20) buttonType:buttonMenuType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    
    self.leftButton.lineThickness = 2;
    self.leftButton.linesColor = [UIColor whiteColor];
    [self.leftButton addTarget:self action:@selector(leftMenuButtonPressed:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tweet:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *todaysDate = [formatter stringFromDate:[NSDate date]];
    
    NSString * someString = [NSString stringWithFormat:@"%@ %@", @"Andrew ID: lfang1", todaysDate];
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [tweetSheet setInitialText: someString];
        
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManger scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
        blutoothisConnected = true;
        
        NSLog(@">>>BLE状态正常");
    }else{
        
        NSLog(@">>>设备不支持BLE或者未打开");
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@">>>>扫描周边设备 .. 设备id:%@, rssi: %@",[peripheral.identifier UUIDString],RSSI);

    peripheral.delegate=self;
    self.peripheral=peripheral;
    [self.centralManger connectPeripheral:self.peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSString *mes = [@"Connected successfully " stringByAppendingString:[peripheral.identifier UUIDString]];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Congratulations"
                              message:mes
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
    [peripheral discoverServices:nil];
    NSLog(@"扫描周边设备上的服务..");
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"发现服务时发生错误: %@",error);
        return;
    }
    NSLog(@"发现服务 ..");
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
//{
//    NSLog(@"发现服务 %@, 特性数: %d", service.UUID, [service.characteristics count]);
//
//    for (CBCharacteristic *c in service.characteristics) {
//        [peripheral readValueForCharacteristic:c];
//        NSLog(@"特性值： %@",c.value);
//    }
//}
- (IBAction)blue:(id)sender {
    if (blutoothisConnected) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Congratulations"
                                  message:@"Bluetooth is powered on"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Please turn on  BlueTooth"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)leftMenuButtonPressed:(VBFPopFlatButton *)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
