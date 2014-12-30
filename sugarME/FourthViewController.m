//
//  FourthViewController.m
//  sugarME
//
//  Created by Maja Kelterborn on 13.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import "FourthViewController.h"
#import "AppDelegate.h"
#import "DetailMaterialViewController.h"

@interface FourthViewController () {
    NSMutableArray *materialNames;
}

@end

@implementation FourthViewController

@synthesize tableView=_tableView;
@synthesize materialNames=_materialNames;
@synthesize managedObjectContext;
@synthesize selectedRowText=_selectedRowText;

-(IBAction)addBarcodeMaterial:(id)sender{
    [self performSegueWithIdentifier:@"showScanner_segue" sender:self];
}

-(IBAction)AddData:(id)sender{
    [self performSegueWithIdentifier:@"showAddMaterial_segue" sender:self];
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
    self.title = @"Material";
    [self performFetches];
    
    UIImage *barcodeImage = [[UIImage imageNamed:@"barcode.png"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    /**
     *  sets an barcode button on the left side in the navigation bar
     */
    UIButton *barcode = [UIButton buttonWithType:UIButtonTypeCustom];
    [barcode addTarget:self
                action:@selector(addBarcodeMaterial:)
      forControlEvents:UIControlEventTouchUpInside];
    barcode.bounds = CGRectMake( 0, 0, 36, 31);
    [barcode setImage:barcodeImage forState:UIControlStateNormal];
    UIBarButtonItem *barcodeButton = [[UIBarButtonItem alloc] initWithCustomView:barcode];
    [self.navigationItem setLeftBarButtonItem:barcodeButton];
    /**
     *  sets an add button on the right side in the navigation bar
     */
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(AddData:)];
    [self.navigationItem setRightBarButtonItem:addButton];
}
/**
 *  load the view new, fetch the latest data and update the tableview
 *
 *  @param animated
 */
-(void) viewWillAppear:(BOOL)animated{
    [self refreshTableView];
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
    return [_materialNames count];
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
    cell.textLabel.text = [_materialNames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
/**
 *  ?
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/**
 *  ?
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        NSFetchRequest *fetchRequestMaterial = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Material" inManagedObjectContext:managedObjectContext];
        [fetchRequestMaterial setEntity:entity];
        NSError *error;
        NSArray *result = [managedObjectContext executeFetchRequest:fetchRequestMaterial error:&error];
        [managedObjectContext deleteObject:[result objectAtIndex:indexPath.row]];
        [appDelegate.managedObjectContext save:&error];
        [_materialNames removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}
/**
 *  set the action for the material rows in the table if they are selected a segue is started to show a new
 *  view
 */

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedRowText = [_materialNames objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showMaterialDetail_segue" sender:self];
}

/**
 *  standard
 */
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
/**
 *  fetch the values from the core data database (sugarmeDB).
 */
-(void)performFetches{
    // Material Daten lesen.
    _materialNames=[[NSMutableArray alloc]initWithObjects:nil];
    NSFetchRequest *fetchRequestMaterial = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Material" inManagedObjectContext:managedObjectContext];
    [fetchRequestMaterial setEntity:entity];
    NSError *error;
    NSArray *result = [managedObjectContext executeFetchRequest:fetchRequestMaterial error:&error];
    for(NSManagedObject *obj in result){
        [_materialNames addObject:[obj valueForKey:@"name"]];
    }
}
/**
 *  refresh the view
 */
-(void)refreshTableView{
    [self performFetches];
    [_tableView reloadData];
}
/**
 *  set action for the material cells - starts DetailMaterialViewController
 *
 *  @param sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMaterialDetail_segue"]) {
        /**
         *  set action for each material cell - starts DetailMaterialViewController
         *
         *  @param sender
         */
        DetailMaterialViewController *vc = [segue destinationViewController];
        /**
         *  passes the textlabel of the selected row to the title of the destination view
         */
        vc.navigationItem.title=_selectedRowText;
    }
}

@end
