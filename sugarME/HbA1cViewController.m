//
//  HbA1c.m
//  SettingsViewController
//
//  Created by Maja Kelterborn on 28.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HbA1cViewController.h"
#import "FifthViewController.h"

@interface HbA1cViewController (){
    NSArray *hba1cTitles;
    NSMutableArray *hba1cData;
    NSMutableArray *anzahlMessungen;
}

@end

@implementation HbA1cViewController

@synthesize tableView = _tableView;
@synthesize pickerTextField = _pickerTextField;
@synthesize pickerView1 = _pickerView1;
@synthesize pickerView2 = _pickerView2;



-(IBAction)SaveData:(id)sender{
    NSLog(@"Tapped Save Data");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hba1cTitles = [[NSArray alloc]initWithObjects:@"Zielbereich", @"Anzahl Messungen pro Jahr", @"Erinnerung", nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    hba1cData = [[NSMutableArray alloc] init];
    for (double i = 3.0; i<=10.0; i++) {
        NSString *myString = [NSString stringWithFormat:@"%f",i];
        [hba1cData addObject:myString];
    }
    
    anzahlMessungen = [[NSMutableArray alloc]init];
    for (int i = 0; i<=6; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [anzahlMessungen addObject:myString];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return hba1cTitles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [hba1cTitles objectAtIndex:indexPath.row];

        if (indexPath.row==0) {
            _pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,10, 280, 30)];
            _pickerView1 = [[UIPickerView alloc] init];
            _pickerView1.dataSource = self;
            _pickerView1.delegate = self;
            _pickerTextField.inputView = _pickerView1;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish)];
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField];
        }
        if (indexPath.row==1){
            _pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,10, 280, 30)];
            _pickerView2 = [[UIPickerView alloc] init];
            _pickerView2.dataSource = self;
            _pickerView2.delegate = self;
            _pickerTextField.inputView = _pickerView2;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish)];
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField];
        }
        if (indexPath.row==2){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
    }
    return cell;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:_pickerView1]) {
        return 4;
    }
    else if ([pickerView isEqual:_pickerView2]){
        return 1;
    }
       else return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual: _pickerView1]){
        if (component==0) {
            return hba1cData.count;
        }else if (component == 1){
            return 1;
        }else if (component == 2){
            return hba1cData.count;
        }
        else if (component == 3){
            return 1;
        }else return 1;
    }
    else if([pickerView isEqual: _pickerView2]){
        return anzahlMessungen.count;
    }else return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([pickerView isEqual:_pickerView1]) {
        if (component==0){
            return [hba1cData objectAtIndex:row];
        }
        else if (component==1){
            return @"-";
        }
        else if (component==2){
            return [hba1cData objectAtIndex:row];
        }
        else if (component==3){
            return @"%";
        }return 0;
    }
    else if ([pickerView isEqual:_pickerView2]){
        return  [anzahlMessungen objectAtIndex:row];
    }else return 0;
}

-(void) inputAccessoryViewDidFinish {
    
    [self.pickerTextField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end