//
//  ThirdViewController.m
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "ThirdViewController.h"
#import "AppDelegate.h"
#import "ValueCell.h"
#import "EmptyCell.h"
#import "HbA1c.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThirdViewController
@synthesize tableWerte=_tableWerte;
@synthesize ampelView=_ampelView;
@synthesize hba1cValues,managedObjectContext;
/**
 *  additional setup after loading the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // set title of the navigation bar
    self.title=@"HbA1c";
    // get the managed object context
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    // setup the add hba1c button, navigation bar top right
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(AddHbA1c:)];
    [self.navigationItem setRightBarButtonItem:addButton];
}
/**
 *  action for the add button --> show add hba1c view
 *
 *  @param sender
 */
-(IBAction)AddHbA1c:(id)sender{
    [self performSegueWithIdentifier:@"showAddHba1c_segue" sender:self];
}
/**
 *  refresh table and ampel view
 *
 *  @param animated
 */
- (void)viewDidAppear:(BOOL)animated {
    [self refreshTableAndAmpelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  return the number of rows in the given section
 *
 *  @param tableView
 *  @param section
 *
 *  @return NSInteger
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hba1cValues.count+1;
}
/**
 *  return the cell for a specific row at given index path
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM - HH:mm"];
    // empty cell on top (black bar)
    if(indexPath.row==0){
        static NSString *emptyCellIdentifier = @"EmptyCell";
        EmptyCell *cell = (EmptyCell *)[tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }else{
        static NSString *valueCellIdentifier = @"ValueCell";
        ValueCell *cell = (ValueCell *)[tableView dequeueReusableCellWithIdentifier:valueCellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ValueCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
            cell.typeLabel.text = @"HbA1c";
            cell.valueLabel.text = [[self.hba1cValues objectAtIndex:indexPath.row-1]valueForKey:@"value"];
            cell.unitLabel.text = @"%";
            cell.timeLabel.text = [dateFormat stringFromDate:[[self.hba1cValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor whiteColor];
        cell.valueTagLabel.backgroundColor=[UIColor colorWithRed:245.0f/255.0f green:155.0f/255.0f blue:199.0f/255.0f alpha:1.0];
        cell.valueTagLabel.text=@"";

    
        return cell;}

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
        [self.managedObjectContext deleteObject:[hba1cValues objectAtIndex:(indexPath.row-1)]];
        [self.managedObjectContext save:&error];
        [self performFetches];
        [_ampelView setNeedsDisplay];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}
/**
 *  returns the height of a row at a specific index path
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
 *  fetch hba1c data from the database sugarmeDB
 */
-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HbA1c" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.hba1cValues =[[managedObjectContext executeFetchRequest:fetchRequest error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];

}
/**
 *  refresh the view
 */
- (void)refreshTableAndAmpelView{
    [self performFetches];
    [_tableWerte reloadData];
    [_ampelView setNeedsDisplay];
}

@end
