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
    
    
}
@end

@implementation EinheitenViewController

@synthesize tableView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    blutzuckerTitles = [[NSArray alloc] initWithObjects:@"mmol/l", @"mg/dl", nil];
    groesseTitles = [[NSArray alloc] initWithObjects:@"Fuss/Zoll", @"Zentimeter", nil];
    gewichtTitles = [[NSArray alloc]initWithObjects:@"Pfund", @"Kilogramm", @"Stone", nil];
    
    self.tableView.allowsMultipleSelection = NO;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (indexPath.section==0) {
        cell.textLabel.text = [blutzuckerTitles objectAtIndex:indexPath.row];
        NSNumber *rowNsNum = [NSNumber numberWithUnsignedInt:indexPath.row];
        if ( [firstSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
           }
    if (indexPath.section==1) {
        cell.textLabel.text = [groesseTitles objectAtIndex:indexPath.row];
        NSNumber *rowNsNum = [NSNumber numberWithUnsignedInt:indexPath.row];
        if ( [secondSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
    if (indexPath.section==2) {
        cell.textLabel.text = [gewichtTitles objectAtIndex:indexPath.row];
        NSNumber *rowNsNum = [NSNumber numberWithUnsignedInt:indexPath.row];
        if ( [ThirdSelectedCellsArray containsObject:rowNsNum]  )
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        NSNumber *rowNumber = [NSNumber numberWithUnsignedInt:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            if ( [firstSelectedCellsArray containsObject:rowNumber]  )
            {
                [firstSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [firstSelectedCellsArray addObject:rowNumber];
            }
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            if ( [firstSelectedCellsArray containsObject:rowNumber]  )
            {
                [firstSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [firstSelectedCellsArray addObject:rowNumber];
            }
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (indexPath.section == 1)
    {
        NSNumber *rowNumber = [NSNumber numberWithUnsignedInt:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            if ( [secondSelectedCellsArray containsObject:rowNumber]  )
            {
                [secondSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [secondSelectedCellsArray addObject:rowNumber];
            }
       
    }
    if (indexPath.section == 2)
    {
        NSNumber *rowNumber = [NSNumber numberWithUnsignedInt:indexPath.row];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
        {
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            if ( [ThirdSelectedCellsArray containsObject:rowNumber]  )
            {
                [ThirdSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [ThirdSelectedCellsArray addObject:rowNumber];
            }
        }
        else if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
        {
            if ( [ThirdSelectedCellsArray containsObject:rowNumber]  )
            {
                [ThirdSelectedCellsArray removeObject:rowNumber];
            }
            else
            {
                [ThirdSelectedCellsArray addObject:rowNumber];
            }
            selectedCell.accessoryType = UITableViewCellAccessoryNone;
        }

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end