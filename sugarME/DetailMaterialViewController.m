//
//  DetailMaterialViewController.m
//  DetailMaterialViewController
//
//  Created by Maja Kelterborn on 13.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "DetailMaterialViewController.h"
#import "AppDelegate.h"
#import "Material.h"

@interface DetailMaterialViewController () {
    NSArray *materialInformations;
    NSArray *materialDetailInformations;
}

@end

@implementation DetailMaterialViewController

@synthesize tableView=_tableView;
@synthesize materialArray,managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    
    materialInformations = [[NSArray alloc] initWithObjects:
                            @"Name",
                            @"Dosis pro Tag",
                            nil];
    
    materialDetailInformations = [[NSArray alloc] initWithObjects:
                                  @"Menge pro Schachtel",
                                  @"Aktuelle Menge",
                                  @"Nachfüllungs Erinnerung",
                                  @"Erinnern",
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
            cell.detailTextLabel.text = self.navigationItem.title;
        }
        else if (indexPath.row == 1){
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"dosis"];
        }
    }
    
    if(indexPath.section==1){
        cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"mengeSchachtel"];
        }
        else if (indexPath.row == 1){
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"mengeAktuell"];
        }
        else if (indexPath.row == 2){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            BOOL on = [[[materialArray lastObject]valueForKey:@"nachfuellen"] boolValue];
            if(on){
                [switchview setOn:YES];
            }else{
                [switchview setOn:NO];
            }
            cell.accessoryView = switchview;
        }
        else if (indexPath.row == 3){
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"erinnern"];
        }
    }
    return cell;
}


-(void)performFetches{
    NSFetchRequest *fetchRequestMaterial = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Material" inManagedObjectContext:managedObjectContext];
    [fetchRequestMaterial setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name == %@", self.navigationItem.title];
    [fetchRequestMaterial setPredicate:predicate];
    NSError *error;
    materialArray = [managedObjectContext executeFetchRequest:fetchRequestMaterial error:&error];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end