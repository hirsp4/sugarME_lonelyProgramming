//
//  AddMaterialViewController.m
//  AddMaterialViewController
//
//  Created by Maja Kelterborn on 15.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "AddMaterialViewController.h"
#import "Material.h"
#import "AppDelegate.h"

@interface AddMaterialViewController () {
    NSArray *materialInformations;
    NSArray *materialDetailInformations;
}

@end

@implementation AddMaterialViewController

@synthesize tableView,managedObjectContext;
@synthesize erinnernSwitch=_erinnernSwitch;
/**
 *  set action for the save button
 *  sets the input values from the user to the textfield in each cell
 *
 *  @param sender
 */
-(IBAction)SaveData:(id)sender{
    UITextField *nameField,*dosisField,*mengeSchachtelField,*mengeAktuellField,*erinnernField;
    NSString *name,*dosis,*mengeSchachtel,*mengeAktuell,*erinnern;
    for (int section = 0; section < 2; section++)
    {
        for(int row = 0; row < 4; row++)
        {
            UITableViewCell *nomeCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
            if(section==0&&row==0){
                nameField=(UITextField*)[nomeCell.contentView viewWithTag:100];
                name=nameField.text;
            }
            if(section==0&&row==1){
                dosisField=(UITextField*)[nomeCell.contentView viewWithTag:101];
                dosis=dosisField.text;
            }
            if(section==1&&row==0){
                mengeSchachtelField=(UITextField*)[nomeCell.contentView viewWithTag:102];
                mengeSchachtel=mengeSchachtelField.text;
            }
            if(section==1&&row==1){
                mengeAktuellField=(UITextField*)[nomeCell.contentView viewWithTag:103];
                mengeAktuell=mengeAktuellField.text;
            }
            if(section==1&&row==3){
                erinnernField=(UITextField*)[nomeCell.contentView viewWithTag:104];
                erinnern=erinnernField.text;
            }
        }
    }
    Material  *materialObjekt = [NSEntityDescription insertNewObjectForEntityForName:@"Material"
                                                              inManagedObjectContext:self.managedObjectContext];
    [materialObjekt setValue:name forKey:@"name"];
    [materialObjekt setValue:dosis forKey:@"dosis"];
    [materialObjekt setValue:mengeSchachtel forKey:@"mengeSchachtel"];
    [materialObjekt setValue:mengeAktuell forKey:@"mengeAktuell"];
    
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
    /**
     * get the object context (to save and fetch data later)
     */
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    /**
     *  sets the title of the view
     */
    self.title= @"Neues Material";
    _erinnernSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    
    /**
     *  fill the tablerow textlabel data
     */
    materialInformations = [[NSArray alloc] initWithObjects:
                            @"Name",
                            @"Dosis pro Tag",
                            nil];
    /**
     *  fill the tablerow textlabel data
     */
    materialDetailInformations = [[NSArray alloc] initWithObjects:
                                  @"Menge pro Schachtel",
                                  @"Aktuelle Menge",
                                  nil];
    
    
    /**
     *  sets an save button on the right side in the navigation bar
     */
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
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
        return materialInformations.count;
    if (section == 1)
        return materialDetailInformations.count;
    return 0;
}
/**
 * sets the title of the headers in the different sections
 *
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Material Informationen";
    if (section == 1)
        return @"Nachfüllungs Informationen";
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        /**
         *  set cell selection style and accessory type
         */
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            /**
             *  init the textfield in the table, where the user can write the input
             *  with a clearbutton
             */
            UITextField *tableTextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 10, 350, 30)];
            tableTextField.delegate =self;
            tableTextField.adjustsFontSizeToFitWidth = YES;
            tableTextField.textColor = [UIColor blackColor];
            tableTextField.backgroundColor = [UIColor whiteColor];
            tableTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            tableTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tableTextField.textAlignment = UITextAlignmentLeft;
            tableTextField.tag = 100;
            tableTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [tableTextField setEnabled: YES];
            
            
            if ([indexPath row] == 0) {
                /**
                 *  init cell material name at row 1 with a placeholder text in the textfield and a keyboard
                 *  which appears when the user taps in the textfield
                 */
                tableTextField.placeholder = [materialInformations objectAtIndex:indexPath.row];
                tableTextField.keyboardType = UIKeyboardTypeAlphabet;
                tableTextField.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tableTextField];
            }
            else if ([indexPath row] == 1) {
                /**
                 *  init cell material dose per day at row 2 with a placeholder text in the textfield and a
                 *  keyboard which appears when the user taps in the textfield
                 */
                tableTextField.placeholder = [materialInformations objectAtIndex:indexPath.row];                 tableTextField.keyboardType = UIKeyboardTypeAlphabet;
                tableTextField.returnKeyType = UIReturnKeyNext;
                tableTextField.tag = 101;
                [cell.contentView addSubview:tableTextField];
            }
        }
        
        if([indexPath section] ==1){
            /**
             *  init the textfield in the table, where the user can write the input
             *  with a clearbutton
             */
            UITextField *table1TextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 10, 350, 30)];
            table1TextField.adjustsFontSizeToFitWidth = YES;
            table1TextField.textColor = [UIColor blackColor];
            table1TextField.adjustsFontSizeToFitWidth = YES;
            table1TextField.backgroundColor = [UIColor whiteColor];
            table1TextField.autocorrectionType = UITextAutocorrectionTypeNo;
            table1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            table1TextField.textAlignment = UITextAlignmentLeft;
            table1TextField.tag = 102;
            table1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [table1TextField setEnabled: YES];
            
            if ([indexPath row] == 0) {
                /**
                 *  init cell material quantity per box at row 1 with a placeholder text in the textfield
                 *  and a keyboard which appears when the user taps in the textfield
                 */
                table1TextField.placeholder = [materialDetailInformations objectAtIndex:indexPath.row];
                table1TextField.keyboardType = UIKeyboardTypeDecimalPad;
                [cell.contentView addSubview:table1TextField];
            }
            else if ([indexPath row] == 1) {
                /**
                 *  init cell material actual quantity at row 2 with a placeholder text in the textfield and
                 *  a keyboard which appears when the user taps in the textfield
                 */
                table1TextField.placeholder = [materialDetailInformations objectAtIndex:indexPath.row];                 table1TextField.keyboardType = UIKeyboardTypeDecimalPad;
                table1TextField.tag = 103;
                [cell.contentView addSubview:table1TextField];
            }
            else if ([indexPath row] == 2){
                /**
                 *  init cell material refill reminder at row 3 with a textlabel and a switch
                 */
                cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
                cell.accessoryView = _erinnernSwitch;
            }
            else if([indexPath row] ==3){
                /**
                 *  init the textfield in the table, where the user can write the input
                 */
                UITextField *table2TextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 180, 30)];
                /**
                 *  init cell material automatic order at row 4 with a placeholder text in the textfield and
                 *  a keyboard
                 *  which appears when the user taps in the textfield
                 */
                cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
                table2TextField.placeholder = @"z.B. 3 Tage vorher";
                table2TextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                table2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                table2TextField.returnKeyType = UIReturnKeyNext;
                table2TextField.textAlignment = UITextAlignmentRight;
                table2TextField.tag = 104;
                [table2TextField setEnabled: YES];
                [cell.contentView addSubview:table2TextField];
            }
            
        }
    }
    
    return cell;
    
}
/**
 *  sets that the keyboard dismisses when the user has ended the editing
 */
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
/**
 *  standard
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
