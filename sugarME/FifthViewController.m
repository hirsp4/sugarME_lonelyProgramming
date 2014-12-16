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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"Einstellungen";
    
    _settingsTitles = [[NSArray alloc] initWithObjects:@"Profil", @"Werte", @"HbA1c", nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _settingsTitles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_settingsTitles objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        _selectedRowText = [_settingsTitles objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showProfileView_segue" sender:self];
    }
    else if (indexPath.row == 1){
        _selectedRowText = [_settingsTitles objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showWerteView_segue" sender:self];
    }
    else if (indexPath.row == 2){
        _selectedRowText = [_settingsTitles objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showHbA1cView_segue" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showProfileView_segue"]) {
        
        // Get destination view
        ProfileViewController *vc = [segue destinationViewController];
        
        vc.navigationItem.title=_selectedRowText;
        
    }
    else if ([[segue identifier] isEqualToString:@"showWerteView_segue"]) {
        
        WerteViewController *vc = [segue destinationViewController];
        
        vc.navigationItem.title=_selectedRowText;
    }
    else if ([[segue identifier] isEqualToString:@"showHbA1cView_segue"]) {
        
        HbA1cViewController *vc = [segue destinationViewController];
        
        vc.navigationItem.title=_selectedRowText;
    }
}

@end
