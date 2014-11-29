//
//  AllgemeinViewController.h
//  SettingsViewController
//
//  Created by Maja Kelterborn on 20.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EinheitenViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *firstSelectedCellsArray;
    NSMutableArray *secondSelectedCellsArray;
    NSMutableArray *ThirdSelectedCellsArray;
    NSIndexPath *checkedIndexPath;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSIndexPath *checkedIndexPath;

@end