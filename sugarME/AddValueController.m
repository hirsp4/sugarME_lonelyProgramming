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
    NSMutableArray *bzValues;
}

@end

@implementation AddValueController
@synthesize blutdruckView,blutzuckerView,pulsView,managedObjectContext,bloodpressurePickerView, pulsPickerView, bloodsugarPickerView;
/**
 *  first method call of view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  get the apps object model, to fetch and store data on the device
     */
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    /**
     *  set pickers vor adding blood pressure, puls oder blood sugar values in the segmented control
     */
    [self setBloodpressurePicker];
    [self setPulsePicker];
    [self setBloodSugarPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  set action of the segmented control: show or hide the specific views.
 *
 *  @param sender
 */
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
/**
 *  set action for the save blood sugar button. stores the user input in the blood sugar entity of the object model
 *
 *  @param sender
 */
- (IBAction)saveBlutzucker:(id)sender {
    Blutzucker *blutzuckerObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Blutzucker"
                                                        inManagedObjectContext:self.managedObjectContext];
    [blutzuckerObjekt setValue:[NSDate date] forKey:@"date"];
    [blutzuckerObjekt setValue:@"" forKey:@"kommentar"];
    [blutzuckerObjekt setValue:@"mmol/l" forKey:@"unit"];
    [blutzuckerObjekt setValue:[bzValues objectAtIndex:[bloodsugarPickerView selectedRowInComponent:1]] forKey:@"value"];
    [blutzuckerObjekt setValue:@"Blutzucker" forKey:@"type"];

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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  set action for the save pulse button. stores the user input in the pulse entity of the object model
 *
 *  @param sender
 */
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Speichern erfolgreich"
                                                        message:@"Die eingegebenen Daten wurden erfolgreich gespeichert"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  set action for the save blood pressure button. stores the user input in the blood pressure entity of the object model
 *
 *  @param sender
 */
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
 *  set the pickerview for adding a blood pressure
 * init with values 90-220 for sys
 * and              40-120 for dia
 * set default values
 */
-(void)setBloodpressurePicker{
    // set the pickerview
    bloodpressurePickerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    bloodpressurePickerView.delegate = self;
    bloodpressurePickerView.dataSource = self;
    bloodpressurePickerView.showsSelectionIndicator = YES;
    bloodpressurePickerView.opaque = NO;
    
    // set range of sys values
    sysValues = [[NSMutableArray alloc] init];
    for (int i = 90; i<=220; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [sysValues addObject:myString];
    }
    // set range of dia values
    diaValues = [[NSMutableArray alloc]init];
    for (int i = 40; i<=120; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [diaValues addObject:myString];
    }
    // set default values
    [self.bloodpressurePickerView selectRow:30 inComponent:1 animated:NO];
    [self.bloodpressurePickerView selectRow:40 inComponent:3 animated:NO];
}
/**
 *  set the pickerview for adding a blood sugar
 * init with values 0-20 (steps of .1)
 * set default value
 */
-(void)setBloodSugarPicker{
    // set the pickerview
    bloodsugarPickerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    bloodsugarPickerView.delegate = self;
    bloodsugarPickerView.dataSource = self;
    bloodsugarPickerView.showsSelectionIndicator = YES;
    bloodsugarPickerView.opaque = NO;
    
    // set range of blood sugar values
    bzValues = [[NSMutableArray alloc] init];
    for (int i = 0; i<=20; i++) {
        for(int j=0; j<=9;j++){
            NSString *myString = [[NSString stringWithFormat:@"%d",i]stringByAppendingString:@"."];
            NSString *myString2 = [myString stringByAppendingString:[NSString stringWithFormat:@"%d",j]];
            [bzValues addObject:myString2];
        }
    }
    // set default value
    [self.bloodsugarPickerView selectRow:40 inComponent:1 animated:NO];
}
/**
 *  set the pickerview for adding a pulse
 * init with values 30-220
 * set default value
 */
-(void)setPulsePicker{
    // set the pickerview
    pulsPickerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    pulsPickerView.delegate = self;
    pulsPickerView.dataSource = self;
    pulsPickerView.showsSelectionIndicator = YES;
    pulsPickerView.opaque = NO;
    
    // set range of pulse values
    pulsValues = [[NSMutableArray alloc] init];
    for (int i = 30; i<=220; i++) {
        NSString *myString = [NSString stringWithFormat:@"%d",i];
        [pulsValues addObject:myString];
    }
    // set default value
    [self.pulsPickerView selectRow:40 inComponent:1 animated:NO];
}
/**
 *  sets the number of components in the picker views
 *
 *  @param pickerView
 *
 *  @return NSInteger
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if([pickerView isEqual: bloodpressurePickerView]){
        return 4;
    }else if([pickerView isEqual: bloodsugarPickerView]){
        return 3;
    }else{
        return 3;
    }
}
/**
 *  sets the number of rows in a component of the picker views
 *
 *  @param pickerView
 *
 *  @return NSInteger
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if([pickerView isEqual: bloodpressurePickerView]){
        if(component==1){
            return sysValues.count;
        }else if(component==3){
            return diaValues.count;
        }else{
            return 1;
        }
    }else if([pickerView isEqual: bloodsugarPickerView]){
        if(component==1){
            return bzValues.count;
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
/**
 *  sets the labels in the rows of the specified component
 *
 *  @param pickerView
 *  @param row
 *  @param component
 *  @param view
 *
 *  @return UIView
 */
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // all this code is needed because there are multiple picker views in the same view controller.
    // check the picker view type, and set the desired labels
    if([pickerView isEqual: bloodpressurePickerView]){
    if(component==0){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        label.text = @"Systole  ";
        label.textColor=[UIColor redColor];
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
        label.textColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
    }else if([pickerView isEqual: bloodsugarPickerView]){
        if(component==0){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 44)];
            label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
            label.text = @"Blutzucker  ";
            label.textAlignment = NSTextAlignmentRight;
            return label;
        }else if(component==2){
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
            label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
            label.text = @"mmol/l  ";
            label.textAlignment = NSTextAlignmentCenter;
            return label;
        }else{
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
            label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont fontWithName:@"Helvetica" size:28];
            label.text = [bzValues objectAtIndex:row];
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
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
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
/**
 *  set the height of a row in the component
 *
 *  @param pickerView
 *  @param component
 *
 *  @return CGFloat
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
@end
