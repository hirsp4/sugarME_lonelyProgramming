//
//  FifthViewController.m
//  SettingsViewController
//
//  Created by Maja Kelterborn on 20.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "FifthViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "WerteViewController.h"
#import "HbA1cViewController.h"


@interface FifthViewController (){
    
    
}
@end

@implementation FifthViewController
@synthesize tableView=_tableView;
@synthesize selectedRowText=_selectedRowText;
@synthesize settingsTitles=_settingsTitles;
/**
 *  triggered when view is called by user.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  sets the title of the view
     */
    self.title=@"Einstellungen";
    /**
     *  fill the tablerow textlabel data
     */
    _settingsTitles = [[NSArray alloc] initWithObjects:@"Profil", @"Werte", @"HbA1c", nil];
}
/**
 *  sets the number of sections in the tableView.
 *
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    return _settingsTitles.count;
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
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    /**
     *  set cell text label and accessory type
     */
    cell.textLabel.text = [_settingsTitles objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
/**
 *  set the action for different rows in the table if they are selected a segue is started to show a new
 *  view
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        /**
         *  init cell for profile at row 0
         */
        _selectedRowText = [_settingsTitles objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showProfileView_segue" sender:self];
    }
    else if (indexPath.row == 1){
        /**
         *  init cell for values at row 1
         */
        _selectedRowText = [_settingsTitles objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showWerteView_segue" sender:self];
    }
    else if (indexPath.row == 2){
        /**
         *  init cell for HbA1c at row 2
         */
        _selectedRowText = [_settingsTitles objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showHbA1cView_segue" sender:self];
    }
}

/**
 *  standard
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  set action for the different cells - starts other controllers
 *
 *  @param sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProfileView_segue"]) {
        /**
         *  set action for the profile cell - starts ProfileViewController
         *
         *  @param sender
         */
        ProfileViewController *vc = [segue destinationViewController];
        /**
         *  passes the textlabel of the selected row to the title of the destination view
         */
        vc.navigationItem.title=_selectedRowText;
        
    }
    else if ([[segue identifier] isEqualToString:@"showWerteView_segue"]) {
        /**
         *  set action for the value cell - starts WerteViewController
         *
         *  @param sender
         */
        WerteViewController *vc = [segue destinationViewController];
        /**
         *  passes the textlabel of the selected row to the title of the destination view
         */
        vc.navigationItem.title=_selectedRowText;
    }
    else if ([[segue identifier] isEqualToString:@"showHbA1cView_segue"]) {
        
        HbA1cViewController *vc = [segue destinationViewController];
        /**
         *  passes the textlabel of the selected row to the title of the destination view
         */
        vc.navigationItem.title=_selectedRowText;
    }

}

@end
