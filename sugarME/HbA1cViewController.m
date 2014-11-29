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
#import "AppDelegate.h"
#import "HbA1cEinstellungen.h"

@interface HbA1cViewController (){
    NSArray *hba1cTitles;
    NSMutableArray *hba1cData;
    NSMutableArray *anzahlMessungen;
}

@end

@implementation HbA1cViewController

@synthesize tableView = _tableView;
@synthesize pickerTextField1 = _pickerTextField1;
@synthesize pickerTextField2 = _pickerTextField2;
@synthesize pickerView1 = _pickerView1;
@synthesize pickerView2 = _pickerView2;
@synthesize hba1cSettings, managedObjectContext;



-(IBAction)SaveData:(id)sender{
    HbA1cEinstellungen  *hba1cObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"HbA1cEinstellungen"
                                                                     inManagedObjectContext:self.managedObjectContext];
    [hba1cObjekt setValue:_pickerTextField1.text forKey:@"zielbereich"];
    [hba1cObjekt setValue:_pickerTextField2.text forKey:@"messungen"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speichern erfolgreich"
                                                        message:@"Die eingegebenen Daten wurden erfolgreich gespeichert"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.managedObjectContext processPendingChanges];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    hba1cTitles = [[NSArray alloc]initWithObjects:@"Zielbereich", @"Anzahl Messungen pro Jahr", @"Erinnerung", nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    hba1cData = [[NSMutableArray alloc] init];
    for (int i = 3; i<=10; i++) {
        for(int j=0; j<=9;j++){
            NSString *myString = [[NSString stringWithFormat:@"%d",i]stringByAppendingString:@"."];
            NSString *myString2 = [myString stringByAppendingString:[NSString stringWithFormat:@"%d",j]];
            [hba1cData addObject:myString2];
        }
    }
    
    anzahlMessungen = [[NSMutableArray alloc]init];
    for (int i = 0; i<=6; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [anzahlMessungen addObject:myString];
    }
    [self setupTextFields];
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
            _pickerView1 = [[UIPickerView alloc] init];
            _pickerView1.dataSource = self;
            _pickerView1.delegate = self;
            _pickerTextField1.inputView = _pickerView1;
            _pickerTextField1.textAlignment=UITextAlignmentRight;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=30000;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField1.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField1];
        }
        if (indexPath.row==1){
            _pickerView2 = [[UIPickerView alloc] init];
            _pickerView2.dataSource = self;
            _pickerView2.delegate = self;
            _pickerTextField2.inputView = _pickerView2;
            _pickerTextField2.textAlignment=UITextAlignmentRight;
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=30001;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            _pickerTextField2.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField2];
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

-(void) inputAccessoryViewDidFinish:(UIBarButtonItem *)button {
    [self.tableView endEditing:YES];
    if(button.tag==30000){
        _pickerTextField1.text=[[[[hba1cData objectAtIndex:[_pickerView1 selectedRowInComponent:0]]stringByAppendingString:@" % - "]stringByAppendingString:[hba1cData objectAtIndex:[_pickerView1 selectedRowInComponent:2]]]stringByAppendingString:@" %"];
    }
    if(button.tag==30001){
        _pickerTextField2.text=[anzahlMessungen objectAtIndex:[_pickerView2 selectedRowInComponent:0]];
    }
    [self.tableView endEditing:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTextFields{
    _pickerTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField1.text=[[self.hba1cSettings lastObject]valueForKey:@"zielbereich"];
    _pickerTextField2.text=[[self.hba1cSettings lastObject]valueForKey:@"messungen"];
}

-(void)performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HbA1cEinstellungen" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.hba1cSettings =[managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}



@end