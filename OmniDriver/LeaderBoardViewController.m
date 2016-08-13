//
//  LeaderScore.m
//  OmniDriver
//
//  Created by Li Fang  on 7/28/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import "LeaderBoardViewController.h"
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

@interface LeaderBoardViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) VBFPopFlatButton *leftButton;
@property (nonatomic, strong) NSString *myScore;
@property (nonatomic, strong) NSString *myEffi;
@property (nonatomic, strong) NSString *myDis;
@end

@implementation LeaderBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // bar and button
    [self makebar];
    [self makeleftbutton];
    [self makerightbutton];
    //
   
    UIColor *my1 = [UIColor colorWithRed:(175/255.0) green:(216/255.0) blue:(238/255.0) alpha:1];
    
    //segentedcontrol
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"Score",@"Efficiency", @"Distance"]];
    
    segmentControl.frame = CGRectMake(-10, 60, self.view.frame.size.width+20, 50);
    [segmentControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl setBackgroundColor:[UIColor whiteColor]];
    [segmentControl setTintColor:[UIColor colorWithRed:(192/255.0) green:(192/255.0) blue:(192/255.0) alpha:1]];
    [self.view addSubview:segmentControl];
    
    // backgroung color
    self.bgview = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 110.0f, SCREEN_WIDTH, 240)];
    self.bgview.backgroundColor =  my1;
    [self.view addSubview:self.bgview];
    // label
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130.0, SCREEN_WIDTH, 50)];
    scoreLabel.text = @"Ranking";
    scoreLabel.textColor = PNWhite;
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    //[titleLabel sizeToFit];
    scoreLabel.font = [UIFont boldSystemFontOfSize:35.0f];
    [self.view addSubview:scoreLabel];
    //image
    UIImage *image = [UIImage imageNamed: @"ranking.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(120,190,SCREEN_WIDTH / 3, SCREEN_WIDTH / 3)];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    
    // tableview definition
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 380, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setScrollEnabled:YES];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectedTitle = @"Score";
    // set the data
    self.titles = [[NSMutableArray alloc] initWithObjects: @"Sophie", @"Peixin Lu", @"Xinqian Li", @"Li Fang", @"Caltin Bai",@"Jessie Qu", @"Lindy Shi", @"Huya Zhi", @"Jessica Hu", @"Meng Shen", @"Han wang", @"Jerry Mosica",nil];
    
    self.images = [[NSMutableArray alloc] initWithObjects:@"car1", @"car2", @"car3", @"car4", @"car5",@"car6", @"car7",@"car8", @"car9", @"car10", @"car11", @"car12",nil];
    
    self.nums = [[NSMutableArray alloc] initWithObjects:@"75.000",@"70.729",@"60.800",@"56.112",@"55.347",@"50.345",@"45.675", @"44.233",@"42.678", @"38.987",@"36.972", @"36.258",nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// to click the segment
-(void)segmentedControlValueDidChange:(UISegmentedControl *)segment
{   //week score
    switch (segment.selectedSegmentIndex) {
        case 0:{
            [self shuffle:self.titles];
            [self shuffle:self.images];
            [self shuffle:self.nums];
            self.myScore = @"75.000";
            [self.tableView reloadData];
            UIColor *myBlueColor = [UIColor colorWithRed:(175/255.0) green:(216/255.0) blue:(238/255.0) alpha:1];
            self.bgview.backgroundColor =  myBlueColor;
            self.selectedTitle = @"Score";
            break;
        }            //week efficiency
        case 1:{
            [self shuffle:self.titles];
            [self shuffle:self.images];
            [self shuffle:self.nums];
            self.myEffi = @"55.675";
            UIColor *myGreenColor = [UIColor colorWithRed:(166/255.0) green:(224/255.0) blue:(165/255.0) alpha:1];
             self.selectedTitle = @"Efficiency";
            self.bgview.backgroundColor = myGreenColor;
            [self.tableView reloadData];
            break;
        }
        case 2: {
            [self shuffle:self.titles];
            [self shuffle:self.images];
            [self shuffle:self.nums];
            self.myDis = @"230.45";
             self.selectedTitle = @"Distance";
            [self.tableView reloadData];
            UIColor *myMintColor = [UIColor colorWithRed:(198/255.0) green:(237/255.0) blue:(232/255.0) alpha:1];
             self.bgview.backgroundColor =  myMintColor;
            break;
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.detailTextLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.detailTextLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%li. %@", indexPath.row+1,self.titles[indexPath.row]];
    cell.detailTextLabel.text = self.nums[indexPath.row];
    
    UIImage *image = [UIImage imageNamed:self.images[indexPath.row]];
    CGSize itemSize = CGSizeMake(60, 40);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.layer.position = CGPointMake(30, 0);
    
    return cell;
}

-(void) makebar{
    self.navigationController.navigationBar.barTintColor = [UIColor flatNavyBlueColorDark];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"LEADER BOARD";
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
        
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@ ranking", self.selectedTitle]];
        

        [tweetSheet addImage:[self imageWithView:self.tableView]];
        
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
-(void) shuffle: (NSMutableArray *)putNumberUsed{
    for (int i = 0; i < putNumberUsed.count; i++) {
        int randomInt1 = arc4random() % [putNumberUsed count];
        int randomInt2 = arc4random() % [putNumberUsed count];
        [putNumberUsed exchangeObjectAtIndex:randomInt1 withObjectAtIndex:randomInt2];
    }
}
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
