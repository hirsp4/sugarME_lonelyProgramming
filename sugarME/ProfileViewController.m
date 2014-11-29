//
//  ProfileViewController.m
//  SettingsViewController
//
//  Created by Maja Kelterborn on 20.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "ProfileViewController.h"
#import "EinheitenViewController.h"
#import "AppDelegate.h"
#import "FifthViewController.h"
#import "Profil.h"


@interface ProfileViewController (){
    NSArray *profileTitles;
    NSArray *genderData;
    NSMutableArray *sizeData;
    NSMutableArray *weightData;
    NSArray *dtypeData;
    NSMutableArray *diagnoseyData;
}
@end

@implementation ProfileViewController

@synthesize tableView = _tableView;
@synthesize selectedRowText=_selectedRowText;
@synthesize pickerTextField1 = _pickerTextField1;
@synthesize pickerTextField2 = _pickerTextField2;
@synthesize pickerTextField3 = _pickerTextField3;
@synthesize pickerTextField4 = _pickerTextField4;
@synthesize pickerTextField5 = _pickerTextField5;
@synthesize vornameTextField = _vornameTextField;
@synthesize nachnameTextField = _nachnameTextField;
@synthesize emailTextField = _emailTextField;
@synthesize dateTextField = _dateTextField;
@synthesize datePicker = _datePicker;
@synthesize pickerView1=_pickerView1;
@synthesize pickerView2 = _pickerView2;
@synthesize pickerView3 = _pickerView3;
@synthesize pickerView4 = _pickerView4;
@synthesize pickerView5 = _pickerView5;
@synthesize pickerDate;
@synthesize managedObjectContext;
@synthesize profil;

-(IBAction)SaveData:(id)sender{
    Profil  *profilObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Profil"
                                                        inManagedObjectContext:self.managedObjectContext];
    [profilObjekt setValue:_vornameTextField.text forKey:@"vorname"];
    [profilObjekt setValue:_nachnameTextField.text forKey:@"nachname"];
    [profilObjekt setValue:_emailTextField.text forKey:@"email"];
    [profilObjekt setValue:_pickerTextField1.text forKey:@"geschlecht"];
    [profilObjekt setValue:_dateTextField.text forKey:@"geburtsdatum"];
    [profilObjekt setValue:_pickerTextField2.text forKey:@"groesse"];
    [profilObjekt setValue:_pickerTextField3.text forKey:@"gewicht"];
    [profilObjekt setValue:_pickerTextField4.text forKey:@"typ"];
    [profilObjekt setValue:_pickerTextField5.text forKey:@"diagnosejahr"];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    
    profileTitles = [[NSArray alloc] initWithObjects:@"Vorname", @"Nachname", @"E-Mail", @"Geschlecht", @"Geburtsdatum", @"Grösse", @"Gewicht", @"Diabetes-Typ", @"Diagnose-Jahr", @"Einheiten", nil];
    
    genderData = [[NSArray alloc] initWithObjects:@"Weiblich", @"Männlich", nil];
    
    sizeData = [[NSMutableArray alloc] init];
    for (int i = 61; i<=210; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [sizeData addObject:myString];
    }
    
    weightData = [[NSMutableArray alloc] init];
    for (int i = 40; i<=150; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [weightData addObject:myString];
    }
    
    dtypeData = [[NSArray alloc] initWithObjects:@"Typ 1", @"Typ 2", nil];
    
    diagnoseyData = [[NSMutableArray alloc] init];
    for (int i = 1914; i<=2000; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [diagnoseyData addObject:myString];
    }
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    [self setupTextFields];



}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return profileTitles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _vornameTextField.placeholder = @"Max";
        _vornameTextField.keyboardType = UIKeyboardTypeDefault;
        _vornameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _vornameTextField.returnKeyType = UIReturnKeyNext;
        _vornameTextField.textAlignment = UITextAlignmentRight;
        [_vornameTextField setEnabled: YES];
        [cell.contentView addSubview:_vornameTextField];
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _nachnameTextField.placeholder = @"Mustermann";
        _nachnameTextField.keyboardType = UIKeyboardTypeDefault;
        _nachnameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nachnameTextField.returnKeyType = UIReturnKeyNext;
        _nachnameTextField.textAlignment = UITextAlignmentRight;
        [_nachnameTextField setEnabled: YES];
        [cell.contentView addSubview:_nachnameTextField];
    }
    
    if (indexPath.row == 2) {
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _emailTextField.placeholder = @"beispiel@mail.com";
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.textAlignment = UITextAlignmentRight;
        [_emailTextField setEnabled: YES];
        [cell.contentView addSubview:_emailTextField];
    }
    
    if (indexPath.row == 3)
    {
        _pickerTextField1.textAlignment=UITextAlignmentRight;
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _pickerView1 = [[UIPickerView alloc] init];
        _pickerView1.dataSource = self;
        _pickerView1.delegate = self;
        _pickerTextField1.inputView = _pickerView1;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
        [myToolbar setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        doneButton.tag=10000;
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        _pickerTextField1.inputAccessoryView = myToolbar;
        [cell.contentView addSubview:_pickerTextField1];
    }
    
    if (indexPath.row == 4)
    {
        _dateTextField.textAlignment=UITextAlignmentRight;
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        _dateTextField.inputView = _datePicker;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
        [myToolbar setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        doneButton.tag=10001;
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        _dateTextField.inputAccessoryView = myToolbar;
        [cell.contentView addSubview:_dateTextField];
        
    }
    
    if (indexPath.row == 5)
    {
        _pickerTextField2.textAlignment=UITextAlignmentRight;
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _pickerView2 = [[UIPickerView alloc] init];
        _pickerView2.dataSource = self;
        _pickerView2.delegate = self;
        _pickerTextField2.inputView = _pickerView2;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
        [myToolbar setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        doneButton.tag=10002;
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        _pickerTextField2.inputAccessoryView = myToolbar;
        [cell.contentView addSubview:_pickerTextField2];
    }
    
    if (indexPath.row == 6)
    {
        _pickerTextField3.textAlignment=UITextAlignmentRight;
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _pickerView3 = [[UIPickerView alloc] init];
        _pickerView3.dataSource = self;
        _pickerView3.delegate = self;
        _pickerTextField3.inputView = _pickerView3;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
        [myToolbar setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        doneButton.tag=10003;
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        _pickerTextField3.inputAccessoryView = myToolbar;
        [cell.contentView addSubview:_pickerTextField3];
    }
    
    if (indexPath.row == 7)
    {
        _pickerTextField4.textAlignment=UITextAlignmentRight;
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _pickerView4 = [[UIPickerView alloc] init];
        _pickerView4.dataSource = self;
        _pickerView4.delegate = self;
        _pickerTextField4.inputView = _pickerView4;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
        [myToolbar setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        doneButton.tag=10004;
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        _pickerTextField4.inputAccessoryView = myToolbar;
        [cell.contentView addSubview:_pickerTextField4];
    }

    if (indexPath.row == 8)
    {
        _pickerTextField5.textAlignment=UITextAlignmentRight;
        cell.textLabel.text = [profileTitles objectAtIndex:indexPath.row];
        _pickerView5 = [[UIPickerView alloc] init];
        _pickerView5.dataSource = self;
        _pickerView5.delegate = self;
        _pickerTextField5.inputView = _pickerView5;
        UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 280, 44)];
        [myToolbar setBarStyle:UIBarStyleBlackOpaque];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(inputAccessoryViewDidFinish:)];
        doneButton.tag=10005;
        [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
        _pickerTextField5.inputAccessoryView = myToolbar;
        [cell.contentView addSubview:_pickerTextField5];
    }

    if (indexPath.row == 9) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
return cell;

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual: _pickerView1]){
        if (component==0) {
            return genderData.count;
        }else return 1;
    }
    else if([pickerView isEqual: _pickerView2]){
        if(component==0){
            return sizeData.count;
        }
        else if (component==1){
            return 1;
        }else return 1;
    }
    else if ([pickerView isEqual:_pickerView3]){
        if (component == 0) {
            return weightData.count;
        }
        else if (component==1){
            return 1;
        }else return 1;
    }
    else if ([pickerView isEqual:_pickerView4]){
        if (component==0) {
            return dtypeData.count;
        }else return 1;
    }
    else if ([pickerView isEqual:_pickerView5]){
        if (component==0) {
            return diagnoseyData.count;
        }else return 1;
    }else return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:_pickerView1]) {
        return 1;
    }
    else if ([pickerView isEqual:_pickerView2]){
        return 2;
    }
    else if ([pickerView isEqual:_pickerView3]){
        return 2;
    }
    else if ([pickerView isEqual:_pickerView4]){
        return 1;
    }
    else if ([pickerView isEqual:_pickerView5]){
        return 1;
    }
    else return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if ([pickerView isEqual:_pickerView1]) {
        return [genderData objectAtIndex:row];
    }
    else if ([pickerView isEqual:_pickerView2]){
        if (component==0) {
            return  [sizeData objectAtIndex:row];
        }
        else if (component==1){
            return @"cm";
        }else {return 0;}
    }
    else if ([pickerView isEqual:_pickerView3]){
        if (component == 0) {
            return  [weightData objectAtIndex:row];
        }
        else if (component == 1){
            return @"kg";
        } else {return 0;}
    }
    else if ([pickerView isEqual:_pickerView4]){
        return [dtypeData objectAtIndex:row];
    }
    else if ([pickerView isEqual:_pickerView5]){
        return [diagnoseyData objectAtIndex:row];
    }else return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {
    _selectedRowText = [profileTitles objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showEinheitenView_segue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEinheitenView_segue"]) {
        
        // Get destination view
        EinheitenViewController *vc = [segue destinationViewController];
        
        vc.navigationItem.title=_selectedRowText;
        
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}


-(void) inputAccessoryViewDidFinish:(UIBarButtonItem *)button {
    [self.tableView endEditing:YES];
    if(button.tag==10000){
        _pickerTextField1.text=[genderData objectAtIndex:[_pickerView1 selectedRowInComponent:0]];
    }
    if(button.tag==10001){
        NSDate *myDate = _datePicker.date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yyyy"];
        NSString *date = [dateFormat stringFromDate:myDate];
         _dateTextField.text=date;
    }
    if(button.tag==10002){
        _pickerTextField2.text=[[sizeData objectAtIndex:[_pickerView2 selectedRowInComponent:0]]stringByAppendingString:@" cm"];
    }
    if(button.tag==10003){
        _pickerTextField3.text=[[weightData objectAtIndex:[_pickerView3 selectedRowInComponent:0]]stringByAppendingString:@" kg"];
    }
    if(button.tag==10004){
        _pickerTextField4.text=[dtypeData objectAtIndex:[_pickerView4 selectedRowInComponent:0]];
    }
    if(button.tag==10005){
        _pickerTextField5.text=[diagnoseyData objectAtIndex:[_pickerView5 selectedRowInComponent:0]];
    }
    [self.tableView endEditing:NO];
}
-(void)setupTextFields{
    _pickerTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField3 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField4 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _pickerTextField5 = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _nachnameTextField = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _vornameTextField = [[UITextField alloc] initWithFrame:CGRectMake(130,10, 180, 30)];
    _dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 180, 30)];
    
    _vornameTextField.text=[[self.profil lastObject]valueForKey:@"vorname"];
    _nachnameTextField.text=[[self.profil lastObject]valueForKey:@"nachname"];
    _emailTextField.text=[[self.profil lastObject]valueForKey:@"email"];
    _pickerTextField1.text=[[self.profil lastObject]valueForKey:@"geschlecht"];
    _dateTextField.text=[[self.profil lastObject]valueForKey:@"geburtsdatum"];
    _pickerTextField2.text=[[self.profil lastObject]valueForKey:@"groesse"];
    _pickerTextField3.text=[[self.profil lastObject]valueForKey:@"gewicht"];
    _pickerTextField4.text=[[self.profil lastObject]valueForKey:@"typ"];
    _pickerTextField5.text=[[self.profil lastObject]valueForKey:@"diagnosejahr"];
    
}

-(void)performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Profil" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.profil =[managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}


@end