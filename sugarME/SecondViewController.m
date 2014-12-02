//
//  SecondViewController.m
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "SecondViewController.h"
#import "ValueCell.h"
#import "EmptyCell.h"
#import "Blutzucker.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize blutzuckerValues, managedObjectContext,pulsValues,blutdruckValues,allValues;
@synthesize tableWerte=_tableWerte;
@synthesize graphView = _graphView;

/**
 *  setup after the loading of the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Werte";
    // get the managed object context to fetch data
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // setup the add button
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(AddData:)];
    [self.navigationItem setRightBarButtonItem:addButton];

    // fetch the desired data
    [self performFetches];
}
/**
 *  set action for the add value button - start AddValueController
 *
 *  @param sender
 */
- (IBAction) AddData:(id)sender {
    [self performSegueWithIdentifier:@"addValueSegue2" sender:self];
}
/**
 *  refresh table and graph views after an adding of a value
 *
 *  @param animated
 */
- (void)viewDidAppear:(BOOL)animated {
    [self refreshTableAndGraphView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  returns the number of rows in a section
 *
 *  @param tableView
 *  @param section
 *
 *  @return NSInteger
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allValues.count+1;
}
/**
 *  return a cell for a specific row at a given index path
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set the date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM - HH:mm"];
    // set an empty cell as start cell of the tableview (black bar)
    if(indexPath.row==0){
        static NSString *emptyCellIdentifier = @"EmptyCell";
        EmptyCell *cell = (EmptyCell *)[tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }else{
        /**
         *  check the type of the given value (blood sugar, blood pressure, pulse) and return
         *  a corresponding cell. Used to generate the different color labels at the beginning of the cell.
         */
    static NSString *valueCellIdentifier = @"ValueCell";
    ValueCell *cell = (ValueCell *)[tableView dequeueReusableCellWithIdentifier:valueCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ValueCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        if ([[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"type"] isEqualToString:@"Blutzucker"]) {
            cell.typeLabel.text = @"Blutzucker";
        cell.valueLabel.text = [[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"value"];
        cell.unitLabel.text = [[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"unit"];
        cell.timeLabel.text = [dateFormat stringFromDate:[[self.allValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor whiteColor];
            cell.valueTagLabel.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
            cell.valueTagLabel.text=@"";

        }
        if ([[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"type"] isEqualToString:@"Blutdruck"]) {
            cell.typeLabel.text = @"Blutdruck";
            cell.valueLabel.text = [[[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"sys"]stringByAppendingString:@"/"]stringByAppendingString:[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"dia"]];
            cell.unitLabel.text = @"mmHG";
            cell.timeLabel.text = [dateFormat stringFromDate:[[self.allValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor whiteColor];
            cell.valueTagLabel.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0];
            cell.valueTagLabel.text=@"";
        }

        if ([[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"type"] isEqualToString:@"Puls"]) {
            cell.typeLabel.text = @"Puls";
            cell.valueLabel.text = [[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"value"];
            cell.unitLabel.text = @"s/min";
            cell.timeLabel.text = [dateFormat stringFromDate:[[self.allValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor whiteColor];
            cell.valueTagLabel.backgroundColor=[UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
            cell.valueTagLabel.text=@"";
        }

            return cell;
    }
}
/**
 *  returns the height of a row at the given index path
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return CGFloat
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 3;
    }
    else return 28;
}
/**
 *  allow editing the table view
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return BOOL
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/**
 *  specify the editing style
 *
 *  @param tableView
 *  @param editingStyle
 *  @param indexPath
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         NSError *error = nil;
        [self.managedObjectContext deleteObject:[allValues objectAtIndex:(indexPath.row-1)]];
        [self.managedObjectContext save:&error];
        [self performFetches];
        [_graphView setNeedsDisplay];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}
/**
 *  merges and sorts 3 input arrays in one output array (sort date descending)
 *
 *  @param arr1
 *  @param arr2
 *  @param arr3
 *
 *  @return NSArray
 */
-(NSArray *)mergeAndSortArray:(NSArray*)arr1 withArray:(NSArray*)arr2 andArray:(NSArray*)arr3{
    NSArray *tempArray = [[arr1 arrayByAddingObjectsFromArray:arr2]arrayByAddingObjectsFromArray:arr3];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
}
/**
 *  return an editing style object (here: delete)
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return UITableViewCellEditingStyle
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

/**
 *  fetch the values from the core data database (sugarmeDB).
 */
-(void) performFetches{
    // fetch blood sugar
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.blutzuckerValues = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // fetch pulse
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Puls" inManagedObjectContext:managedObjectContext];
    [fetchRequest2 setEntity:entity];
    self.pulsValues = [managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
    // fetch blood pressure
    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Blutdruck" inManagedObjectContext:managedObjectContext];
    [fetchRequest3 setEntity:entity];
    self.blutdruckValues = [managedObjectContext executeFetchRequest:fetchRequest3 error:&error];
    allValues = [self mergeAndSortArray:blutdruckValues withArray:pulsValues andArray:blutzuckerValues];
}
/**
 *  refresh tables and graph view
 */
- (void)refreshTableAndGraphView{
    [self performFetches];
    [_tableWerte reloadData];
    [_graphView setNeedsDisplay];
}


@end
