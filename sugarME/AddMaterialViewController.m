//
//  AddMaterialViewController.m
//  sugarME
//
//  Created by Fresh Prince on 16.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "AddMaterialViewController.h"
#import "Material.h"
#import "AppDelegate.h"

@interface AddMaterialViewController ()

@end

@implementation AddMaterialViewController
@synthesize managedObjectContext, materialText;

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
- (IBAction)saveMaterial:(id)sender {
    Material  *materialObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Material"
                                                        inManagedObjectContext:self.managedObjectContext];
    [materialObjekt setValue:materialText.text forKey:@"name"];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
    }else{
    materialText.text=@"";
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
    [materialText resignFirstResponder];
}


@end
