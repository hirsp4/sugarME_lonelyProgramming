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

-(IBAction)EditData:(id)sender{
    NSLog(@"Tapped Edit Data");
}

-(IBAction)AddData:(id)sender{
    [self performSegueWithIdentifier:@"showAddMaterial_segue" sender:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    self.title = @"Material";
    [self performFetches];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Bearbeiten" style:UIBarButtonItemStyleDone target:self action:@selector(EditData:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(AddData:)];
    [self.navigationItem setRightBarButtonItem:addButton];
}
-(void) viewWillAppear:(BOOL)animated{
    [self refreshTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView :(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_materialNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_materialNames objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
        [_materialNames removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedRowText = [_materialNames objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showMaterialDetail_segue" sender:self];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

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
-(void)refreshTableView{
    [self performFetches];
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMaterialDetail_segue"]) {
        
        // Get destination view
        DetailMaterialViewController *vc = [segue destinationViewController];
        
        
        // Pass the information to your destination view
        vc.navigationItem.title=_selectedRowText;
    }
}

@end
