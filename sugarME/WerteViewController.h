//
//  WerteViewController.h
//  SettingsViewController
//
//  Created by Maja Kelterborn on 21.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WerteViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong,nonatomic) UITextField *pickerTextField;
@property (strong, nonatomic) UIPickerView *pickerView1;
@property (strong, nonatomic) UIPickerView *pickerView2;
@property (strong, nonatomic) UIPickerView *pickerView3;
@property (strong, nonatomic) UIPickerView *pickerView4;
@property (strong, nonatomic) UIPickerView *pickerView5;
@property (strong, nonatomic) UIPickerView *pickerView6;





@end