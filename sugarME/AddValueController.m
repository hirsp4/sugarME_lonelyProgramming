//
//  AddValueController.m
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "AddValueController.h"
#import "Blutzucker.h"
#import "Puls.h"
#import "Blutdruck.h"
#import "AppDelegate.h"
#import "SecondViewController.h"

@interface AddValueController (){
    NSMutableArray *sysValues;
    NSMutableArray *diaValues;
    NSMutableArray *pulsValues;
}

@end

@implementation AddValueController
@synthesize blutdruckView,blutzuckerView,pulsView,managedObjectContext,blutzuckerText,kommentarText, pulsText, sysText,diaText,bloodpressurePickerView, pulsPickerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    [self setBloodpressurePicker];
    [self setPulsePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.blutzuckerView.hidden=NO;
            self.blutdruckView.hidden=YES;
            self.pulsView.hidden=YES;
            break;
        case 1:
            self.blutzuckerView.hidden=YES;
            self.blutdruckView.hidden=NO;
            self.pulsView.hidden=YES;
            break;
        case 2:
            self.blutzuckerView.hidden=YES;
            self.blutdruckView.hidden=YES;
            self.pulsView.hidden=NO;
            break;
        default:
            break;
    }
}

- (IBAction)saveBlutzucker:(id)sender {
    Blutzucker *blutzuckerObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Blutzucker"
                                                        inManagedObjectContext:self.managedObjectContext];
    [blutzuckerObjekt setValue:[NSDate date] forKey:@"date"];
    [blutzuckerObjekt setValue:kommentarText.text forKey:@"kommentar"];
    [blutzuckerObjekt setValue:@"mmol/l" forKey:@"unit"];
    [blutzuckerObjekt setValue:blutzuckerText.text forKey:@"value"];
    [blutzuckerObjekt setValue:@"Blutzucker" forKey:@"type"];

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
        blutzuckerText.text=@"";
        kommentarText.text=@"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speichern erfolgreich"
                                                        message:@"Die eingegebenen Daten wurden erfolgreich gespeichert"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)savePuls:(id)sender {
    Puls *pulsObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Puls"
                                                                 inManagedObjectContext:self.managedObjectContext];
    [pulsObjekt setValue:[NSDate date] forKey:@"date"];
    [pulsObjekt setValue:[pulsValues objectAtIndex:[pulsPickerView selectedRowInComponent:1]] forKey:@"value"];
    [pulsObjekt setValue:@"Puls" forKey:@"type"];

    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
        pulsText.text=@"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speichern erfolgreich"
                                                        message:@"Die eingegebenen Daten wurden erfolgreich gespeichert"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)saveBlutdruck:(id)sender {
    Blutdruck *blutdruckObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Blutdruck"
                                                     inManagedObjectContext:self.managedObjectContext];
    [blutdruckObjekt setValue:[NSDate date] forKey:@"date"];
    [blutdruckObjekt setValue:[sysValues objectAtIndex:[bloodpressurePickerView selectedRowInComponent:1]] forKey:@"sys"];
    [blutdruckObjekt setValue:[diaValues objectAtIndex:[bloodpressurePickerView selectedRowInComponent:3]] forKey:@"dia"];
    [blutdruckObjekt setValue:@"Blutdruck" forKey:@"type"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
        sysText.text=@"";
        diaText.text=@"";
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
-(void)dismissKeyboard {
    [kommentarText resignFirstResponder];
    [blutzuckerText resignFirstResponder];
    [pulsText resignFirstResponder];
    [sysText resignFirstResponder];
    [diaText resignFirstResponder];
}
-(void)setBloodpressurePicker{
    bloodpressurePickerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    
    bloodpressurePickerView.delegate = self;
    bloodpressurePickerView.dataSource = self;
    bloodpressurePickerView.showsSelectionIndicator = YES;
    bloodpressurePickerView.opaque = NO;
    
    sysValues = [[NSMutableArray alloc] init];
    for (int i = 90; i<=220; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [sysValues addObject:myString];
    }
    diaValues = [[NSMutableArray alloc]init];
    for (int i = 40; i<=120; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [diaValues addObject:myString];
    }
    [self.bloodpressurePickerView selectRow:30 inComponent:1 animated:NO];
    [self.bloodpressurePickerView selectRow:40 inComponent:3 animated:NO];
}

-(void)setPulsePicker{
    pulsPickerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    pulsPickerView.delegate = self;
    pulsPickerView.dataSource = self;
    pulsPickerView.showsSelectionIndicator = YES;
    pulsPickerView.opaque = NO;
    
    pulsValues = [[NSMutableArray alloc] init];
    for (int i = 30; i<=220; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [pulsValues addObject:myString];
    }
    [self.pulsPickerView selectRow:40 inComponent:1 animated:NO];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if([pickerView isEqual: bloodpressurePickerView]){
        return 4;
    }else{
        return 3;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual: bloodpressurePickerView]){
        if(component==1){
            return sysValues.count;
        }else if(component==3){
            return diaValues.count;
        }else{
            return 1;
        }
    }else{
        if(component==1){
            return pulsValues.count;
        }else{
            return 1;
        }
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if([pickerView isEqual: bloodpressurePickerView]){
    if(component==0){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        label.text = @"Systole  ";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else if (component==1){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:28];
        label.text = [sysValues objectAtIndex:row];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    else if (component==3){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:28];
        label.text = [diaValues objectAtIndex:row];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else{
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        label.text = @"Diastole  ";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    }else{
        if(component==0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
            label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
            label.text = @"Puls  ";
            label.textAlignment = NSTextAlignmentCenter;
            return label;
        }else if(component==2){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
            label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Helvetica" size:28];
            label.text = @"s/min  ";
            label.textAlignment = NSTextAlignmentCenter;
            return label;
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Helvetica" size:28];
            label.text = [pulsValues objectAtIndex:row];
            label.textAlignment = NSTextAlignmentCenter;
            return label;
        }
    }
    
}
@end
