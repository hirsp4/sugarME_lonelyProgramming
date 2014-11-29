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
@property (strong,nonatomic) UISwitch *bzErinnerungSwitch;
@property (strong,nonatomic) UISwitch *pulsErinnerungSwitch;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *werteeinstellungen;

@property (strong,nonatomic) UITextField *pickerTextField1;
@property (strong,nonatomic) UITextField *pickerTextField2;
@property (strong,nonatomic) UITextField *pickerTextField3;
@property (strong,nonatomic) UITextField *pickerTextField4;
@property (strong,nonatomic) UITextField *pickerTextField5;
@property (strong,nonatomic) UITextField *pickerTextField6;


@end