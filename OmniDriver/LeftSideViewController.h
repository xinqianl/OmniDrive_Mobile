//
//  LeftSideViewController.h
//  OmniDriver
//
//  Created by Li Fang  on 7/21/16.
//  Copyright © 2016 Li Fang . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface LeftSideViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>

- (IBAction)userSettingButtonClick:(id)sender;

@end
