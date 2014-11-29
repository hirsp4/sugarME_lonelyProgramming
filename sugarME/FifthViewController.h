//
//  FifthViewController.h
//  SettingsViewController
//
//  Created by Maja Kelterborn on 20.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FifthViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *selectedRowText;
@property (strong, nonatomic) NSArray *settingsTitles;


@end

