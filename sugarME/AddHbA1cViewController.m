//
//  AddHbA1cViewController.m
//  sugarME
//
//  Created by Fresh Prince on 14.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "AddHbA1cViewController.h"
#import "HbA1c.h"
#import "AppDelegate.h"

@interface AddHbA1cViewController (){
    NSMutableArray *hba1cValues;
}

@end

@implementation AddHbA1cViewController
@synthesize managedObjectContext, hba1cText, hba1cPickerView;
/**
 *  additional setup after loading the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // get the managed object context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // set uipickerview
    [self setHba1cPicker];
}
/**
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  returns the number of components in the specified picker view
 *
 *  @param pickerView
 *
 *  @return NSInteger
 */
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
        return 3;
}
/**
 *  returns the number of rows in a given component of the specified picker view
 *
 *  @param pickerView
 *  @param component
 *
 *  @return NSInteger
 */
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==1){
       return hba1cValues.count;
    }else{
        return 1;
    }
    
}
/**
 *  sets labels for the rows of the picker view
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
    // first column of picker view
    if(component==0){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        label.text = @"HbA1c  ";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else if(component==2){
        // third column of picker view
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        label.text = @"%  ";
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }else{
        // second column of picker view
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        label.backgroundColor = [UIColor colorWithRed:200.0f/255.0f green:218.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Helvetica" size:28];
        label.text = [hba1cValues objectAtIndex:row];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
}
/**
 *  returns the row height for a component
 *
 *  @param pickerView
 *  @param component
 *
 *  @return CGFloat
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50;
}
/**
 *  setting the add hba1c date picker
 */
-(void)setHba1cPicker{
    hba1cPickerView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    hba1cPickerView.delegate = self;
    hba1cPickerView.dataSource = self;
    hba1cPickerView.showsSelectionIndicator = YES;
    hba1cPickerView.opaque = NO;
    
    hba1cValues = [[NSMutableArray alloc] init];
    // init with values from 0.0 to 20.9
    for (int i = 0; i<=20; i++) {
        for(int j=0; j<=9;j++){
            NSString *myString = [[NSString stringWithFormat:@"%d",i]stringByAppendingString:@"."];
            NSString *myString2 = [myString stringByAppendingString:[NSString stringWithFormat:@"%d",j]];
            [hba1cValues addObject:myString2];
        }
    }
    [self.hba1cPickerView selectRow:40 inComponent:1 animated:NO];
}
/**
 *  code for the save button
 *
 *  @param sender
 */
- (IBAction)saveHbA1c:(id)sender {
    // build the object
    HbA1c  *hba1cObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"HbA1c"
                                                               inManagedObjectContext:self.managedObjectContext];
    [hba1cObjekt setValue:[NSDate date] forKey:@"date"];
    [hba1cObjekt setValue:[hba1cValues objectAtIndex:[hba1cPickerView selectedRowInComponent:1]] forKey:@"value"];
    NSError *error;
    // store it in the database sugarmeDB
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
        hba1cText.text=@"";
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


@end
