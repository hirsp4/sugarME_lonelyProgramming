//
//  DetailMaterialViewController.m
//  DetailMaterialViewController
//
//  Created by Maja Kelterborn on 13.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "DetailMaterialViewController.h"

@interface DetailMaterialViewController () {
    NSArray *materialInformations;
    NSArray *materialDetailInformations;
}

@end

@implementation DetailMaterialViewController

@synthesize tableView=_tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    materialInformations = [[NSArray alloc] initWithObjects:
                            @"Name",
                            @"Dosis pro Tag",
                            @"Bild",
                            @"Nicht mehr in Gebrauch",
                            nil];
    
    materialDetailInformations = [[NSArray alloc] initWithObjects:
                                  @"Menge pro Schachtel",
                                  @"Aktuelle Menge",
                                  @"Nachfüllungs Erinnerung",
                                  @"Erinnern",
                                  @"Zeit",
                                  @"Automatische Bestellung",
                                  nil];
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
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    
    if (indexPath.section==0) {
        cell.textLabel.text = [materialInformations objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.title;
        }
        else if (indexPath.row == 1){
            cell.detailTextLabel.text = @"4 Einheiten";
        }
        else if (indexPath.row == 2){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumblantus-1.jpg"]];
            cell.accessoryView = imageView;
        }
        else if (indexPath.row == 3){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
        }
    }
    
    if(indexPath.section==1){
        cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"1500 Einheiten";
        }
        else if (indexPath.row == 1){
            cell.detailTextLabel.text = @"300 Einheiten";
        }
        else if (indexPath.row == 2){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
        }
        else if (indexPath.row == 3){
            cell.detailTextLabel.text = @"3 Tage vorher";
        }
        else if (indexPath.row == 4){
            cell.detailTextLabel.text = @"14:00, jede Stunde";
        }
        else if (indexPath.row == 5){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            cell.accessoryView = switchview;
        }
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end