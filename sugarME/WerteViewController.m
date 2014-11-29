//
//  WerteViewController.m
//  SettingsViewController
//
//  Created by Maja Kelterborn on 21.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WerteViewController.h"
#import "FifthViewController.h"

@interface WerteViewController (){
    NSArray *blutzuckerTitles;
    NSArray *bdpulsTitles;
    NSMutableArray *bzunterezielData;
    NSMutableArray *bzoberezielData;
    NSMutableArray *anzahlMessungen;
    NSMutableArray *bdsyszielData;
    NSMutableArray *bddiazielData;
    NSMutableArray *pulszielData;
}

@end

@implementation WerteViewController

@synthesize tableView = _tableView;
@synthesize pickerTextField = _pickerTextField;
@synthesize pickerView1 = _pickerView1;
@synthesize pickerView2 = _pickerView2;
@synthesize pickerView3 = _pickerView3;
@synthesize pickerView4 = _pickerView4;
@synthesize pickerView5 = _pickerView5;
@synthesize pickerView6 = _pickerView6;


-(IBAction)SaveData:(id)sender{
    NSLog(@"Tapped Save Data");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    blutzuckerTitles = [[NSArray alloc]initWithObjects:@"Messgerät", @"Zielbereich", @"Anzahl Messungen pro Tag", @"Erinnerung", nil];
    
    bdpulsTitles = [[NSArray alloc] initWithObjects:@"Messgerät", @"Zielbereich Systole", @"Zielbereich Diastole", @"Zielbereich Ruhepuls", @"Anzahl Messungen pro Tag", @"Erinnerung", nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    bzunterezielData = [[NSMutableArray alloc] init];
    for (double i = 3.0; i<=6.0; i++) {
        NSString *myString = [NSString stringWithFormat:@"%lf",i];
        [bzunterezielData addObject:myString];
    }
    
    bzoberezielData = [[NSMutableArray alloc] init];
    for (double i = 4.0; i<=7.0; i++) {
        NSString *myString = [NSString stringWithFormat:@"%lf",i];
        [bzoberezielData addObject:myString];
    }
    
    anzahlMessungen = [[NSMutableArray alloc]init];
    for (int i = 0; i<=10; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [anzahlMessungen addObject:myString];
    }
    
    bdsyszielData = [[NSMutableArray alloc] init];
    for (int i = 90; i<=180; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [bdsyszielData addObject:myString];
    }

    bddiazielData = [[NSMutableArray alloc] init];
    for (int i = 50; i<=120; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [bddiazielData addObject:myString];
    }
    
    pulszielData = [[NSMutableArray alloc]init];
    for (int i = 40; i<=140; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [pulszielData addObject:myString];
    }

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return blutzuckerTitles.count;
    if (section == 1){
        return bdpulsTitles.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Blutzucker";
    if (section == 1) {
        return @"Blutdruck/Puls";
    }
    return @"undefined";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.textLabel.text = [blutzuckerTitles objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==1){
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
        else if (indexPath.row==2){
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
        else if (indexPath.row==3){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
        }
    }
    if (indexPath.section==1){
        cell.textLabel.text = [bdpulsTitles objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==1){
            _pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,10, 280, 30)];
            _pickerView3 = [[UIPickerView alloc] init];
            _pickerView3.dataSource = self;
            _pickerView3.delegate = self;
            _pickerTextField.inputView = _pickerView3;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish)];
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField];
        }
        else if (indexPath.row==2){
            _pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,10, 280, 30)];
            _pickerView4 = [[UIPickerView alloc] init];
            _pickerView4.dataSource = self;
            _pickerView4.delegate = self;
            _pickerTextField.inputView = _pickerView4;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish)];
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField];
        }
        else if (indexPath.row==3){
            _pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,10, 280, 30)];
            _pickerView5 = [[UIPickerView alloc] init];
            _pickerView5.dataSource = self;
            _pickerView5.delegate = self;
            _pickerTextField.inputView = _pickerView5;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish)];
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField];
        }
        else if (indexPath.row==4){
            _pickerTextField = [[UITextField alloc] initWithFrame:CGRectMake(120,10, 280, 30)];
            _pickerView6 = [[UIPickerView alloc] init];
            _pickerView6.dataSource = self;
            _pickerView6.delegate = self;
            _pickerTextField.inputView = _pickerView6;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish)];
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField];
        }
        else if (indexPath.row==5){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
        }
    
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
        else if ([pickerView isEqual:_pickerView3]){
            return 4;
        }
        else if ([pickerView isEqual:_pickerView4]){
            return 4;
        }
        else if ([pickerView isEqual:_pickerView5]){
            return 4;
        }
        else if ([pickerView isEqual:_pickerView5]){
            return 4;
        }
        else if ([pickerView isEqual:_pickerView6]){
            return 1;
        }
        else return 1;
}

    
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual: _pickerView1]){
        if (component==0) {
            return bzunterezielData.count;
        }else if (component == 1){
            return 1;
        }else if (component == 2){
            return bzoberezielData.count;
        }
        else if (component == 3){
            return 1;
        }else return 1;
    }
    else if([pickerView isEqual: _pickerView2]){
            return anzahlMessungen.count;
    }
    else if ([pickerView isEqual:_pickerView3]){
        if (component == 0) {
            return bdsyszielData.count;
        }
        else if (component==1){
            return 1;
        }else if (component==2){
            return bdsyszielData.count;
        }
        else if (component==3){
            return 1;
        }else return 1;
    }
    else if ([pickerView isEqual:_pickerView4]){
        if (component == 0) {
            return bddiazielData.count;
        }
        else if (component==1){
            return 1;
        }else if (component==2){
            return bddiazielData.count;
        }
        else if (component==3){
            return 1;
        }else return 1;
    }
    else if ([pickerView isEqual:_pickerView5]){
        if (component == 0) {
            return pulszielData.count;
        }
        else if (component==1){
            return 1;
        }else if (component==2){
            return pulszielData.count;
        }
        else if (component==3){
            return 1;
        }else return 1;
    }
    else if([pickerView isEqual: _pickerView6]){
        if (component==0) {
            return anzahlMessungen.count;
    }else return 1;
}else return 0;

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
        if ([pickerView isEqual:_pickerView1]) {
            if (component==0){
                return [bzunterezielData objectAtIndex:row];
            }
            else if (component==1){
                return @"-";
            }
            else if (component==2){
                return [bzoberezielData objectAtIndex:row];
            }
            else if (component==3){
                return @"mmol/l";
            }return 0;
        }
        else if ([pickerView isEqual:_pickerView2]){
                return  [anzahlMessungen objectAtIndex:row];
        }
        else if ([pickerView isEqual:_pickerView3]){
            if (component == 0) {
                return  [bdsyszielData objectAtIndex:row];
            }
            else if (component == 1){
                return @"-";
            }
            else if (component==2){
                return [bdsyszielData objectAtIndex:row];
            }
            else if (component==3){
                return @"mmHg";
            }else {return 0;}
        }
        else if ([pickerView isEqual:_pickerView4]){
            if (component == 0) {
                return  [bddiazielData objectAtIndex:row];
            }
            else if (component == 1){
                return @"-";
            }
            else if (component==2){
                return [bddiazielData objectAtIndex:row];
            }
            else if (component==3){
                return @"mmHg";
            }else {return 0;}
        }
        else if ([pickerView isEqual:_pickerView5]){
            if (component == 0) {
                return  [pulszielData objectAtIndex:row];
            }
            else if (component == 1){
                return @"-";
            }
            else if (component==2){
                return [pulszielData objectAtIndex:row];
            }
            else if (component==3){
                return @"bpm";
            }else {return 0;}
        }
        else if ([pickerView isEqual:_pickerView5]){
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