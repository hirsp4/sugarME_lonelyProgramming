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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"HbA1c";
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(AddHbA1c:)];
    [self.navigationItem setRightBarButtonItem:addButton];


}
-(IBAction)AddHbA1c:(id)sender{
    [self performSegueWithIdentifier:@"showAddHba1c_segue" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self refreshTableAndAmpelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hba1cValues.count+1;
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
            cell.typeLabel.text = @"HbA1c";
            cell.valueLabel.text = [[self.hba1cValues objectAtIndex:indexPath.row-1]valueForKey:@"value"];
            cell.unitLabel.text = @"%";
            cell.timeLabel.text = [dateFormat stringFromDate:[[self.hba1cValues objectAtIndex:indexPath.row-1] valueForKey:@"date"]];
            cell.backgroundColor= [UIColor whiteColor];
        cell.valueTagLabel.backgroundColor=[UIColor colorWithRed:245.0f/255.0f green:155.0f/255.0f blue:199.0f/255.0f alpha:1.0];
        cell.valueTagLabel.text=@"";

    
        return cell;}

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 3;
    }
    else return 28;
}

-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HbA1c" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.hba1cValues =[[managedObjectContext executeFetchRequest:fetchRequest error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];

}
- (void)refreshTableAndAmpelView{
    [self performFetches];
    [_tableWerte reloadData];
    [_ampelView setNeedsDisplay];
}

@end
