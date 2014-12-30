//
//  AllgemeinViewController.m
//  SettingsViewController
//
//  Created by Maja Kelterborn on 20.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "EinheitenViewController.h"
#import "ProfileViewController.h"
#import "FifthViewController.h"

@interface EinheitenViewController (){
    NSArray *blutzuckerTitles;
    NSArray *groesseTitles;
    NSArray *gewichtTitles;
    NSIndexPath *firstSectionIndex;
    NSIndexPath *secondSectionIndex;
    NSIndexPath *thirdSectionIndex;
    
}
@end

@implementation EinheitenViewController

@synthesize tableView;
/**
 *  triggered when view is called by user.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  fill the tablerow textlabel data
     */
    blutzuckerTitles = [[NSArray alloc] initWithObjects:@"mmol/l", @"mg/dl", nil];
    groesseTitles = [[NSArray alloc] initWithObjects:@"Zentimeter", @"Fuß/Zoll", nil];
    gewichtTitles = [[NSArray alloc]initWithObjects:@"Kilogramm", @"Pfund",  @"Stone", nil];
    
    self.tableView.allowsMultipleSelection = NO;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
}
/**
 *  sets the number of sections in the tableView.
 *
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
        return groesseTitles.count;
    }
    if (section == 2){
        return gewichtTitles.count;
    }
    return 0;
}
/**
 * sets the title of the headers in the different sections
 *
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Blutzucker";
    if (section == 1) {
        return @"Körpergrösse";
    }
    if (section == 2) {
        return @"Gewicht";
    }
    return @"undefined";
}
/**
 *  sets the cell for a specific row in the tableview
 *  used in this project: MeasureCell, HighLowCell
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return UITableViewCell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1dR%1d",indexPath.row,indexPath.section];
    /**
     *  init the cells
     */
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSUserDefaults *savedState = [NSUserDefaults standardUserDefaults];
        
        /**
         *  set the cell selections style, with no color
         */
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section)
        {
                /**
                 *  sets the first case in the switch with the specific values to compare with ohter cases
                 */
            case 0:
            {
                NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row];
                if([[savedState objectForKey:@"firstSectionIndex"] isEqual: indexNumber])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    firstSectionIndex = indexPath;
                }
                
                if (indexPath.row == 0)
                {
                    /**
                     *  sets as accessory type a checkmark to the first row of the first section
                     *  and sets the textlabel to the first row of the first section
                     */
                    NSObject * checkedCellObject = [savedState objectForKey:@"firstSectionIndex"];
                    if(checkedCellObject == nil)
                    {
                        firstSectionIndex = indexPath;
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    cell.textLabel.text = [blutzuckerTitles objectAtIndex:indexPath.row];
                }
                /**
                 *  sets the textlabel to the second row of the first section
                 */
                if (indexPath.row == 1)
                {
                    cell.textLabel.text = [blutzuckerTitles objectAtIndex:indexPath.row];
                }
            }
                break;
                /**
                 *  sets the second case in the switch with the specific values to compare with ohter cases
                 */
            case 1:
            {
                NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row];
                if([[savedState objectForKey:@"secondSectionIndex"] isEqual: indexNumber])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    secondSectionIndex = indexPath;
                }
                
                if (indexPath.row == 0)
                {
                    /**
                     *  sets as accessory type a checkmark to the first row of the second section
                     *  and sets the textlabel to the first row of the second section
                     */
                    NSObject * checkedCellObject = [savedState objectForKey:@"secondSectionIndex"];
                    if(checkedCellObject == nil)
                    {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        secondSectionIndex = indexPath;
                    }
                    cell.textLabel.text = [groesseTitles objectAtIndex:indexPath.row];
                }
                /**
                 *  sets the textlabel to the second row of the second section
                 */
                if (indexPath.row == 1)
                {
                    cell.textLabel.text = [groesseTitles objectAtIndex:indexPath.row];
                }
            }
                break;
                /**
                 *  sets the third case in the switch with the specific values to compare with ohter cases
                 */
            case 2:
            {
                NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row];
                if([[savedState objectForKey:@"thirdSectionIndex"] isEqual: indexNumber])
                {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    thirdSectionIndex = indexPath;
                }
                
                if (indexPath.row == 0)
                {
                    /**
                     *  sets as accessory type a checkmark to the first row of the third section
                     *  and sets the textlabel to the first row of the third section
                     */
                    NSObject * checkedCellObject = [savedState objectForKey:@"thirdSectionIndex"];
                    if(checkedCellObject == nil)
                    {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                        thirdSectionIndex = indexPath;
                    }
                    cell.textLabel.text = [gewichtTitles objectAtIndex:indexPath.row];
                }
                /**
                 *  sets the textlabel to the second row of the third section
                 */
                if (indexPath.row == 1)
                {
                    cell.textLabel.text = [gewichtTitles objectAtIndex:indexPath.row];
                }
                /**
                 *  sets the textlabel to the third row of the third section
                 */
                if (indexPath.row == 2)
                {
                    cell.textLabel.text = [gewichtTitles objectAtIndex:indexPath.row];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}
/**
 *  set the action for different rows in the table if they are selected a checkmark is set as the accessory
 *  type in the row
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        UITableViewCell *checkCell = [tableView cellForRowAtIndexPath:indexPath];
        if(firstSectionIndex && firstSectionIndex != indexPath)
        {
            UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:firstSectionIndex];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        firstSectionIndex = indexPath;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:firstSectionIndex.row] forKey:@"firstSectionIndex"];
        checkCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    if (indexPath.section == 1)
    {
        UITableViewCell *checkCell = [tableView cellForRowAtIndexPath:indexPath];
        if(secondSectionIndex)
        {
            UITableViewCell *unchekCell = [tableView cellForRowAtIndexPath:secondSectionIndex];
            unchekCell.accessoryType = UITableViewCellAccessoryNone;
        }
        secondSectionIndex = indexPath;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:secondSectionIndex.row] forKey:@"secondSectionIndex"];
        checkCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (indexPath.section == 2)
    {
        UITableViewCell *checkCell = [tableView cellForRowAtIndexPath:indexPath];
        if(thirdSectionIndex)
        {
            UITableViewCell *unchekCell = [tableView cellForRowAtIndexPath:thirdSectionIndex];
            unchekCell.accessoryType = UITableViewCellAccessoryNone;
        }
        thirdSectionIndex = indexPath;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:thirdSectionIndex.row] forKey:@"thirdSectionIndex"];
        checkCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}
/**
 *  standard
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end