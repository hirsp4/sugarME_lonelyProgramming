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
    [self performFetches];
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
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:CellIdentifier];
    
    if (indexPath.section==0) {
        /**
         *  init cells at section 0
         */
        cell.textLabel.text = [materialInformations objectAtIndex:indexPath.row];
        /**
         *  init cell for material name at row 0
         */
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.navigationItem.title;
        }
        /**
         *  init cell for material dose per day at row 1
         */
        else if (indexPath.row == 1){
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"dosis"];
        }
    }
    
    if(indexPath.section==1){
        /**
         *  init cells at section 0
         */
        cell.textLabel.text = [materialDetailInformations objectAtIndex:indexPath.row];
        /**
         *  init cell for material menge pro schachtel at row 0
         */
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"mengeSchachtel"];
        }
        /**
         *  init cell for material aktuelle menge at row 1
         */
        else if (indexPath.row == 1){
            cell.detailTextLabel.text = [[materialArray lastObject]valueForKey:@"mengeAktuell"];
        }
        /**
         *  init cell for material nachfüllen at row 2
         */
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
/**
 *  fetch the values from the core data database (sugarmeDB).
 */
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
/**
 *  standard
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end