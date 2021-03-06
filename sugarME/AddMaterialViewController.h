//
//  AddMaterialViewController.h
//  AddMaterialViewController
//
//  Created by Maja Kelterborn on 15.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMaterialViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property NSMutableArray *dataArray;
@property UISwitch *erinnernSwitch;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
