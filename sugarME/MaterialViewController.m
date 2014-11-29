//
//  MaterialViewController.m
//  SettingsViewController
//
//  Created by Maja Kelterborn on 28.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaterialViewController.h"
#import "FifthViewController.h"

@interface MaterialViewController (){
    NSArray *materialTitles;
}

@end

@implementation MaterialViewController

@synthesize tableView = _tableView;

-(IBAction)SaveData:(id)sender{
    NSLog(@"Tapped Save Data");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    materialTitles = [[NSArray alloc]initWithObjects:@"App-Symbol anzeigen (Badge)", @"Apotheke für automatische Bestellung", @"Rezept für automatische Bestellung", nil];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Sichern" style:UIBarButtonItemStyleDone target:self action:@selector(SaveData:)];
    [self.navigationItem setRightBarButtonItem:saveButton];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return materialTitles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==0) {
        cell.textLabel.text = [materialTitles objectAtIndex:indexPath.row];
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;
    }
    if (indexPath.row==1) {
        cell.textLabel.text = [materialTitles objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==2) {
        cell.textLabel.text = [materialTitles objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end