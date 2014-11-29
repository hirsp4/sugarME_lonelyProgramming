//
//  HbA1c.h
//  SettingsViewController
//
//  Created by Maja Kelterborn on 28.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HbA1cViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UITextField *pickerTextField1;
@property (strong,nonatomic) UITextField *pickerTextField2;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *hba1cSettings;

@property (strong, nonatomic) UIPickerView *pickerView1;
@property (strong, nonatomic) UIPickerView *pickerView2;

@end