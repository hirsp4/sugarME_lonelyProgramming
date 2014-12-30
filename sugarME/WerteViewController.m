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
#import "AppDelegate.h"
#import "Werteeinstellungen.h"


@interface WerteViewController (){
    NSArray *blutzuckerTitles;
    NSArray *bdpulsTitles;
    NSMutableArray *bzunterezielData;
    NSMutableArray *bzoberezielData;
    NSMutableArray *anzahlMessungen;
    NSMutableArray *anzahlMessungen2;
    NSMutableArray *bdsyszielData;
    NSMutableArray *bddiazielData;
    NSMutableArray *pulszielData;
}

@end
/**
 *  global variables
 */
@implementation WerteViewController

@synthesize tableView = _tableView;
@synthesize pickerTextField = _pickerTextField;
@synthesize pickerView1 = _pickerView1;
@synthesize pickerView2 = _pickerView2;
@synthesize pickerView3 = _pickerView3;
@synthesize pickerView4 = _pickerView4;
@synthesize pickerView5 = _pickerView5;
@synthesize pickerView6 = _pickerView6;
@synthesize pickerTextField1 = _pickerTextField1;
@synthesize pickerTextField2 = _pickerTextField2;
@synthesize pickerTextField3 = _pickerTextField3;
@synthesize pickerTextField4 = _pickerTextField4;
@synthesize pickerTextField5 = _pickerTextField5;
@synthesize pickerTextField6 = _pickerTextField6;
@synthesize bzErinnerungSwitch = _bzErinnerungSwitch;
@synthesize pulsErinnerungSwitch = _pulsErinnerungSwitch;
@synthesize managedObjectContext,werteeinstellungen;

/**
 *  set action for the save button
 *  sets the selected value from the picker to the textfield in each cell
 *
 *  @param sender
 */
-(IBAction)SaveData:(id)sender{
    Werteeinstellungen  *werteObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Werteeinstellungen"
                                                                     inManagedObjectContext:self.managedObjectContext];
    [werteObjekt setValue:_pickerTextField1.text forKey:@"bzzielbereich"];
    [werteObjekt setValue:_pickerTextField2.text forKey:@"bzmessungen"];
    [werteObjekt setValue:_pickerTextField3.text forKey:@"syszielbereich"];
    [werteObjekt setValue:_pickerTextField4.text forKey:@"diazielbereich"];
    [werteObjekt setValue:_pickerTextField5.text forKey:@"pulszielbereich"];
    [werteObjekt setValue:_pickerTextField6.text forKey:@"pulsmessungen"];
    [werteObjekt setValue:[NSNumber numberWithBool:_bzErinnerungSwitch.on] forKey:@"bzerinnerung"];
    [werteObjekt setValue:[NSNumber numberWithBool:_pulsErinnerungSwitch.on] forKey:@"pulserinnerung"];
    
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
/**
 *  triggered when view is called by user.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    [self setupArrays];
    [self setupTextFields];
}
/**
 *  sets the number of sections in the tableView.
 *
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
/**
 *  sets the number of rows in the specific section.
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return blutzuckerTitles.count;
    if (section == 1){
        return bdpulsTitles.count;
    }
    return 0;
}
/**
 *  sets the title of the header in the specific section.
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Blutzucker";
    if (section == 1) {
        return @"Blutdruck/Puls";
    }
    return @"undefined";
}
/**
 *  sets the cell for a specific row in the tableview
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return UITableViewCell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    /**
     *  init the cells
     */
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /**
     *  set cell text label, selection style no color and cell accessory
     */
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        cell.textLabel.text = [blutzuckerTitles objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==1){
            /**
             * set the pickerview for adding a zielbereich of the values
             *
             * set default values
             */
            _pickerView1 = [[UIPickerView alloc] init];
            _pickerView1.dataSource = self;
            _pickerView1.delegate = self;
            _pickerTextField1.textAlignment=UITextAlignmentRight;
            _pickerTextField1.inputView = _pickerView1;
            /**
             * set the toolbar over the pickerview with the done button, when a value is selected
             *
             */
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=20000;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            /**
             * set the textfield in the cell where the value of the pickerview is shown
             *
             */
            _pickerTextField1.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField1];
            
        }
        else if (indexPath.row==2){
            /**
             * set the pickerview for adding a zielbereich of the values
             *
             * set default values
             */
            _pickerView2 = [[UIPickerView alloc] init];
            _pickerView2.dataSource = self;
            _pickerView2.delegate = self;
            _pickerTextField2.textAlignment=UITextAlignmentRight;
            _pickerTextField2.inputView = _pickerView2;
            /**
             * set the toolbar over the pickerview with the done button, when a value is selected
             *
             */
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=20001;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            /**
             * set the textfield in the cell where the value of the pickerview is shown
             *
             */
            _pickerTextField2.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField2];
        }
        else if (indexPath.row==3){
            cell.accessoryView = _bzErinnerungSwitch;
        }
    }
    if (indexPath.section==1){
        cell.textLabel.text = [bdpulsTitles objectAtIndex:indexPath.row];
        if (indexPath.row==0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row==1){
            /**
             * set the pickerview for adding a zielbereich of the values
             *
             * set default values
             */
            _pickerView3 = [[UIPickerView alloc] init];
            _pickerView3.dataSource = self;
            _pickerView3.delegate = self;
            _pickerTextField3.textAlignment=UITextAlignmentRight;
            _pickerTextField3.inputView = _pickerView3;
            /**
             * set the toolbar over the pickerview with the done button, when a value is selected
             *
             */
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=20002;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            /**
             * set the textfield in the cell where the value of the pickerview is shown
             *
             */
            _pickerTextField3.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField3];
        }
        else if (indexPath.row==2){
            /**
             * set the pickerview for adding a zielbereich of the values
             *
             * set default values
             */
            _pickerView4 = [[UIPickerView alloc] init];
            _pickerView4.dataSource = self;
            _pickerView4.delegate = self;
            _pickerTextField4.textAlignment=UITextAlignmentRight;
            _pickerTextField4.inputView = _pickerView4;
            /**
             * set the toolbar over the pickerview with the done button, when a value is selected
             *
             */
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=20003;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            /**
             * set the textfield in the cell where the value of the pickerview is shown
             *
             */
            _pickerTextField4.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField4];
        }
        else if (indexPath.row==3){
            /**
             * set the pickerview for adding a zielbereich of the values
             *
             * set default values
             */
            _pickerView5 = [[UIPickerView alloc] init];
            _pickerView5.dataSource = self;
            _pickerView5.delegate = self;
            _pickerTextField5.textAlignment=UITextAlignmentRight;
            _pickerTextField5.inputView = _pickerView5;
            /**
             * set the toolbar over the pickerview with the done button, when a value is selected
             *
             */
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=20004;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            /**
             * set the textfield in the cell where the value of the pickerview is shown
             *
             */
            _pickerTextField5.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField5];
        }
        else if (indexPath.row==4){
            /**
             * set the pickerview for adding a zielbereich of the values
             *
             * set default values
             */
            _pickerView6 = [[UIPickerView alloc] init];
            _pickerView6.dataSource = self;
            _pickerView6.delegate = self;
            _pickerTextField6.textAlignment=UITextAlignmentRight;
            _pickerTextField6.inputView = _pickerView6;
            /**
             * set the toolbar over the pickerview with the done button, when a value is selected
             *
             */
            UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
            [myToolbar setBarStyle:UIBarStyleBlackOpaque];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
            doneButton.tag=20005;
            [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
            /**
             * set the textfield in the cell where the value of the pickerview is shown
             *
             */
            _pickerTextField6.inputAccessoryView = myToolbar;
            [cell.contentView addSubview:_pickerTextField6];
        }
        else if (indexPath.row==5){
            cell.accessoryView = _pulsErinnerungSwitch;
        }
        
    }
    return cell;
}
/**
 *  sets the number of components in the picker views
 *
 *  @param pickerView
 *
 *  @return NSInteger
 */
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
/**
 *  sets the number of rows in a component of the picker views
 *
 *  @param pickerView
 *
 *  @return NSInteger
 */
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
    else if([pickerView isEqual:_pickerView6]){
        return anzahlMessungen2.count;
    }else return 0;
    
}
/**
 *  sets the titles in the rows of the specified component
 *
 *  @param pickerView
 *  @param row
 *  @param component
 *  @param view
 *
 *  @return UIView
 */
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
    else if ([pickerView isEqual:_pickerView6]){
        return  [anzahlMessungen2 objectAtIndex:row];
    }else return 0;
}
/**
 *  sets the values and data in the textfield, when the done button was selected in the pickerviews
 */
-(void) inputAccessoryViewDidFinish:(UIBarButtonItem *)button {
    [self.tableView endEditing:YES];
    if(button.tag==20000){
        _pickerTextField1.text=[[[[bzunterezielData objectAtIndex:[_pickerView1 selectedRowInComponent:0]]stringByAppendingString:@"-"]stringByAppendingString:[bzoberezielData objectAtIndex:[_pickerView1 selectedRowInComponent:2]]]stringByAppendingString:@" mmol/l"];
    }
    if(button.tag==20001){
        _pickerTextField2.text=[anzahlMessungen objectAtIndex:[_pickerView2 selectedRowInComponent:0]];
    }
    if(button.tag==20002){
        _pickerTextField3.text=[[[[bdsyszielData objectAtIndex:[_pickerView3 selectedRowInComponent:0]]stringByAppendingString:@"-"]stringByAppendingString:[bdsyszielData objectAtIndex:[_pickerView3 selectedRowInComponent:2]]]stringByAppendingString:@" mmHG"];
    }
    if(button.tag==20003){
        _pickerTextField4.text=[[[[bddiazielData objectAtIndex:[_pickerView4 selectedRowInComponent:0]]stringByAppendingString:@"-"]stringByAppendingString:[bddiazielData objectAtIndex:[_pickerView4 selectedRowInComponent:2]]]stringByAppendingString:@" mmHG"];
    }
    if(button.tag==20004){
        _pickerTextField5.text=[[[[pulszielData objectAtIndex:[_pickerView5 selectedRowInComponent:0]]stringByAppendingString:@"-"]stringByAppendingString:[pulszielData objectAtIndex:[_pickerView5 selectedRowInComponent:2]]]stringByAppendingString:@" s/min"];
    }
    if(button.tag==20005){
        _pickerTextField6.text=[anzahlMessungen objectAtIndex:[_pickerView6 selectedRowInComponent:0]];
    }
    [self.tableView endEditing:NO];
}

/**
 *  sets the textfields for each row in the tableview
 */
-(void)setupTextFields{
    _pickerTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField5 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField6 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _bzErinnerungSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    _pulsErinnerungSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    
    _pickerTextField1.text=[[self.werteeinstellungen lastObject]valueForKey:@"bzzielbereich"];
    _pickerTextField2.text=[[self.werteeinstellungen lastObject]valueForKey:@"bzmessungen"];
    _pickerTextField3.text=[[self.werteeinstellungen lastObject]valueForKey:@"syszielbereich"];
    _pickerTextField4.text=[[self.werteeinstellungen lastObject]valueForKey:@"diazielbereich"];
    _pickerTextField5.text=[[self.werteeinstellungen lastObject]valueForKey:@"pulszielbereich"];
    _pickerTextField6.text=[[self.werteeinstellungen lastObject]valueForKey:@"pulsmessungen"];
    BOOL bzOn = [[[self.werteeinstellungen lastObject]valueForKey:@"bzerinnerung"] boolValue];
    BOOL pulsOn= [[[self.werteeinstellungen lastObject]valueForKey:@"pulserinnerung"] boolValue];
    
    if(bzOn){
        [_bzErinnerungSwitch setOn:YES];
    }else{
        [_bzErinnerungSwitch setOn:NO];
    }
    if(pulsOn){
        [_pulsErinnerungSwitch setOn:YES];
    }else{
        [_pulsErinnerungSwitch setOn:NO];
    }
}
/**
 *  sets the arrays for the different tablerow header data
 */
-(void)setupArrays{
    /**
     *  fill the blood sugar tablerow header data
     */
    blutzuckerTitles = [[NSArray alloc]initWithObjects:@"Messgerät", @"Zielbereich", @"Anzahl Messungen pro Tag", @"Erinnerung", nil];
    /**
     *  fill the blood pressure tablerow header data
     */
    bdpulsTitles = [[NSArray alloc] initWithObjects:@"Messgerät", @"Zielbereich Systole", @"Zielbereich Diastole", @"Zielbereich Ruhepuls", @"Anzahl Messungen pro Tag", @"Erinnerung", nil];
    
    /**
     *set low range of blood sugar values
     */
    bzunterezielData = [[NSMutableArray alloc] init];
    for (int i = 3; i<=6; i++) {
        for(int j=0; j<=9;j++){
            NSString *myString = [[NSString stringWithFormat:@"%d",i]stringByAppendingString:@"."];
            NSString *myString2 = [myString stringByAppendingString:[NSString stringWithFormat:@"%d",j]];
            [bzunterezielData addObject:myString2];
        }
    }
    /**
     * set high range of blood sugar values
     */
    bzoberezielData = [[NSMutableArray alloc] init];
    for (int i = 4; i<=7; i++) {
        for(int j=0; j<=9;j++){
            NSString *myString = [[NSString stringWithFormat:@"%d",i]stringByAppendingString:@"."];
            NSString *myString2 = [myString stringByAppendingString:[NSString stringWithFormat:@"%d",j]];
            [bzoberezielData addObject:myString2];
        }
    }
    /**
     * set range of quantity of blood sugar measurements
     */
    anzahlMessungen = [[NSMutableArray alloc]init];
    for (int i = 0; i<=10; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [anzahlMessungen addObject:myString];
    }
    /**
     * set high range of blood pressure values
     */
    bdsyszielData = [[NSMutableArray alloc] init];
    for (int i = 90; i<=180; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [bdsyszielData addObject:myString];
    }
    /**
     * set low range of blood pressure values
     */
    bddiazielData = [[NSMutableArray alloc] init];
    for (int i = 50; i<=120; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [bddiazielData addObject:myString];
    }
    /**
     * set range of pulse values
     */
    pulszielData = [[NSMutableArray alloc]init];
    for (int i = 40; i<=140; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [pulszielData addObject:myString];
    }
    /**
     * set range of quantity of blood pressure and pulse measurements
     */
    anzahlMessungen2 = [[NSMutableArray alloc]init];
    for (int i = 0; i<=10; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [anzahlMessungen2 addObject:myString];
    }
    
}
/**
 *  standard
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  fetch the values from the core data database (sugarmeDB).
 */
-(void)performFetches{
    // fetch value settings
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Werteeinstellungen" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.werteeinstellungen =[managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

@end