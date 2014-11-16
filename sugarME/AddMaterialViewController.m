//
//  AddMaterialViewController.m
//  AddMaterialViewController
//
//  Created by Maja Kelterborn on 15.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "AddMaterialViewController.h"

@interface AddMaterialViewController () {
    NSArray *materialInformations;
    NSArray *materialDetailInformations;
}

@end

@implementation AddMaterialViewController

@synthesize tableView;

-(IBAction)SaveData:(id)sender{
    NSLog(@"Tapped Save Data");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title= @"Neues Material";
    
    materialInformations = [[NSArray alloc] initWithObjects:
                            @"Name",
                            @"Dosis pro Tag",
                            nil];
    
    materialDetailInformations = [[NSArray alloc] initWithObjects:
                                  @"Menge pro Schachtel",
                                  @"Aktuelle Menge",
                                  @"Nachfüllungs Erinnerung",
                                  @"Erinnern",
                                  @"Zeit",
                                  @"Automatische Bestellung",
                                  nil];
    
    
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return materialInformations.count;
    if (section == 1)
        return materialDetailInformations.count;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Material Informationen";
    if (section == 1)
        return @"Nachfüllungs Informationen";
    return @"undefined";
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            UITextField *tableTextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 10, 350, 30)];
            tableTextField.adjustsFontSizeToFitWidth = YES;
            tableTextField.textColor = [UIColor blackColor];
            tableTextField.backgroundColor = [UIColor whiteColor];
            tableTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            tableTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tableTextField.textAlignment = UITextAlignmentLeft;
            tableTextField.tag = 0;
            tableTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [tableTextField setEnabled: YES];
            
            
            if ([indexPath row] == 0) {
                tableTextField.placeholder = [materialInformations objectAtIndex:indexPath.row];
                tableTextField.keyboardType = UIKeyboardTypeAlphabet;
                tableTextField.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tableTextField];
            }
            else if ([indexPath row] == 1) {
                tableTextField.placeholder = [materialInformations objectAtIndex:indexPath.row];                 tableTextField.keyboardType = UIKeyboardTypeAlphabet;
                tableTextField.returnKeyType = UIReturnKeyNext;
                [cell.contentView addSubview:tableTextField];
            }
        }
        
        if([indexPath section] ==1){
            UITextField *table1TextField = [[UITextField alloc] initWithFrame:CGRectMake(18, 10, 350, 30)];
            table1TextField.adjustsFontSizeToFitWidth = YES;
            table1TextField.textColor = [UIColor blackColor];
            table1TextField.adjustsFontSizeToFitWidth = YES;
            table1TextField.backgroundColor = [UIColor whiteColor];
            table1TextField.autocorrectionType = UITextAutocorrectionTypeNo;
            table1TextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            table1TextField.textAlignment = UITextAlignmentLeft;
            table1TextField.tag = 0;
            table1TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [table1TextField setEnabled: YES];
            
            if ([indexPath row] == 0) {
                table1TextField.placeholder = [materialDetailInformations objectAtIndex:indexPath.row];
                table1TextField.keyboardType = UIKeyboardTypeDecimalPad;
                [cell.contentView addSubview:table1TextField];
            }
            else if ([indexPath row] == 1) {
                table1TextField.placeholder = [materialDetailInformations objectAtIndex:indexPath.row];                 table1TextField.keyboardType = UIKeyboardTypeDecimalPad;
                [cell.contentView addSubview:table1TextField];
            }
            else if ([indexPath row] == 2){
                cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
                UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchview;
            }
            else if([indexPath row] ==3){
                UITextField *table2TextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, 280, 30)];
                cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
                table2TextField.placeholder = @"z.B. 3 Tage vorher";
                table2TextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                table2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                table2TextField.returnKeyType = UIReturnKeyNext;
                table2TextField.textAlignment = UITextAlignmentRight;
                [table2TextField setEnabled: YES];
                [cell.contentView addSubview:table2TextField];
            }
            else if ([indexPath row] ==4){
                UITextField *table2TextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 10, 300, 30)];
                cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
                table2TextField.placeholder = @"z.B. 14:00 Uhr, jede Stunde";
                table2TextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                table2TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                table2TextField.returnKeyType = UIReturnKeyNext;
                table2TextField.textAlignment = UITextAlignmentRight;
                [table2TextField setEnabled: YES];
                [cell.contentView addSubview:table2TextField];
            }
            else if ([indexPath row] == 5){
                cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
                UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                cell.accessoryView = switchview;
            }
            
        }
    }
    
    return cell;
    
}
-(void)dismissKeyboard {
[self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
