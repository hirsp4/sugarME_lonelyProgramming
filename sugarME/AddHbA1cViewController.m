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

@interface AddHbA1cViewController ()

@end

@implementation AddHbA1cViewController
@synthesize managedObjectContext, hba1cText;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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

- (IBAction)saveHbA1c:(id)sender {
    HbA1c  *hba1cObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"HbA1c"
                                                               inManagedObjectContext:self.managedObjectContext];
    [hba1cObjekt setValue:[NSDate date] forKey:@"date"];
    [hba1cObjekt setValue:hba1cText.text forKey:@"value"];
    NSError *error;
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
-(void)dismissKeyboard {
    [hba1cText resignFirstResponder];
}


@end
