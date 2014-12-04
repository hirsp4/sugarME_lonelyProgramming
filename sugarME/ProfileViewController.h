//
//  ProfileViewController.h
//  SettingsViewController
//
//  Created by Serafin Albin on 20.11.14.
//  Copyright (c) 2014 Serafin Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *selectedRowText;
@property (strong,nonatomic) UITextField *pickerTextField1;
@property (strong,nonatomic) UITextField *pickerTextField2;
@property (strong,nonatomic) UITextField *pickerTextField3;
@property (strong,nonatomic) UITextField *pickerTextField4;
@property (strong,nonatomic) UITextField *pickerTextField5;
@property (strong,nonatomic) UITextField *dateTextField;
@property (strong,nonatomic) UITextField *vornameTextField;
@property (strong,nonatomic) UITextField *nachnameTextField;
@property (strong,nonatomic) UITextField *emailTextField;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) NSArray *profil;
@property (strong, nonatomic) UIPickerView *pickerView1;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIPickerView *pickerView2;
@property (strong, nonatomic) UIPickerView *pickerView3;
@property (strong, nonatomic) UIPickerView *pickerView4;
@property (strong, nonatomic) UIPickerView *pickerView5;
@property (strong, nonatomic) NSDate *pickerDate;


@end

