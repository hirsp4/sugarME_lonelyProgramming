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

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
}
- (void)viewDidAppear:(BOOL)animated {
    [self refreshTableAndGraphView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allValues.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM - HH:mm"];
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
        if ([[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"type"] isEqualToString:@"Blutzucker"]) {
            cell.typeLabel.text = @"Blutzucker";
        cell.valueLabel.text = [[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"value"];
        cell.unitLabel.text = [[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"unit"];
        cell.timeLabel.text = [dateFormat stringFromDate:[[self.allValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];

        }
        if ([[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"type"] isEqualToString:@"Blutdruck"]) {
            cell.typeLabel.text = @"Blutdruck";
            cell.valueLabel.text = [[[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"sys"]stringByAppendingString:@"/"]stringByAppendingString:[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"dia"]];
            cell.unitLabel.text = @"mmHG";
            cell.timeLabel.text = [dateFormat stringFromDate:[[self.allValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        }

        if ([[[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"type"] isEqualToString:@"Puls"]) {
            cell.typeLabel.text = @"Puls";
            cell.valueLabel.text = [[self.allValues objectAtIndex:indexPath.row-1]valueForKey:@"value"];
            cell.unitLabel.text = @"s/min";
            cell.timeLabel.text = [dateFormat stringFromDate:[[self.allValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];

            
        }

            return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 3;
    }
    else return 28;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self refreshTableAndGraphView];
    }
}
-(NSArray *)mergeAndSortArray:(NSArray*)arr1 withArray:(NSArray*)arr2 andArray:(NSArray*)arr3{
    NSArray *tempArray = [[arr1 arrayByAddingObjectsFromArray:arr2]arrayByAddingObjectsFromArray:arr3];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.blutzuckerValues = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Puls" inManagedObjectContext:managedObjectContext];
    [fetchRequest2 setEntity:entity];
    self.pulsValues = [managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Blutdruck" inManagedObjectContext:managedObjectContext];
    [fetchRequest3 setEntity:entity];
    self.blutdruckValues = [managedObjectContext executeFetchRequest:fetchRequest3 error:&error];
    allValues = [self mergeAndSortArray:blutdruckValues withArray:pulsValues andArray:blutzuckerValues];
}

- (void)refreshTableAndGraphView{
    [self performFetches];
    [_tableWerte reloadData];
    [_graphView setNeedsDisplay];
}


@end
