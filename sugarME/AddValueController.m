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

@interface AddValueController ()

@end

@implementation AddValueController
@synthesize blutdruckView,blutzuckerView,pulsView,managedObjectContext,blutzuckerText,kommentarText, pulsText, sysText,diaText;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
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
    [pulsObjekt setValue:pulsText.text forKey:@"value"];
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
    [blutdruckObjekt setValue:sysText.text forKey:@"sys"];
    [blutdruckObjekt setValue:diaText.text forKey:@"dia"];
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
@end
