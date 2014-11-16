//
//  DetailMaterialViewController.h
//  sugarME
//
//  Created by Maja Kelterborn on 13.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMaterialViewController : UIViewController
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property NSMutableArray *dataArray;
@end
