//
//  FirstViewController.m
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "FirstViewController.h"
#import "HighLowCell.h"
#import "MeasureCell.h"
#import "UserCell.h"
#import "Blutzucker.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@end
/**
 *  global variables
 */
@implementation FirstViewController{
    NSArray *tableData;
    float maxValue;
    float minValue;
}
@synthesize tableWerte=_tableWerte;
@synthesize blutzuckerValues, managedObjectContext, pulsValues, blutdruckValues, werteEinstellungen;
/**
 *  triggered when view is called by user.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    /**
     *  values to check the state of the bloodsugar values
     * <3.5 or >5.7 red, else green
     */
    minValue = 3.5f;
    maxValue = 5.7f;
    /**
     * get the object context (to save and fetch data later)
     */
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    /**
     *  fill the tablerow header data
     */
    tableData = [NSArray arrayWithObjects:@"Blutzuckermessungen",@"Blutzucker Werte dieser Woche (mmol/l)", @"Blutdruck Werte dieser Woche (mmHg)", @"Puls Werte dieser Woche (s/min)", nil];
    /**
     * init info button top right of the screen
     */
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(showInfo:)];
    /**
     * init export button top left of the screen (to get to the pdf reader)
     */
     UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportData:)];
    /**
     *  add buttons to the navigation bar of the view
     */
    self.navigationItem.rightBarButtonItem = infoButton;
    self.navigationItem.leftBarButtonItem = exportButton;
    /**
     *  retrieve data (blood sugar values, blood pressure values, pulse values) from the coredata object model (fill the arrays specified as properties in the header file).
     */
    [self performFetches];
    
}
/**
 *  load the view new, fetch the latest data and update the tableview
 *
 *  @param animated
 */
-(void) viewWillAppear:(BOOL)animated{
    [self performFetches];
    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath* indexPath3 = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath* indexPath4 = [NSIndexPath indexPathForRow:3 inSection:0];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,indexPath4, nil];
    [_tableWerte reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];}

/**
 *  standard
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  sets the number of rows in the specific section.
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}
/**
 *  sets the cell for a specific row in the tableview
 *  used in this project: MeasureCell, HighLowCell
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return UITableViewCell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     * set the date Format to dd.MM. - HH:mm
     */
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM. - HH:mm"];
    static NSString *highLowCellIdentifier = @"HighLowCell";
    HighLowCell *cell = (HighLowCell *)[tableView dequeueReusableCellWithIdentifier:highLowCellIdentifier];
    if(indexPath.row==0){
        /**
         *  init Measure Cell at row 0
         */
        MeasureCell *cell2 = (MeasureCell *)[tableView dequeueReusableCellWithIdentifier:@"MeasureCell"];
        if (cell2 == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeasureCell" owner:self options:nil];
            cell2 = [nib objectAtIndex:0];
        }
        /**
         *  set Add Button
         */
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self
                   action:@selector(buttonTouchUpInside:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"+" forState:UIControlStateNormal];
        button.frame = CGRectMake(35.0f, 35.0f, 35.0f, 35.0f);
        CGRect btFrame = button.frame;
        btFrame = CGRectMake(self.view.frame.size.width - button.frame.size.width - 3, cell2.frame.origin.y, button.frame.size.width, button.frame.size.height);
        button.frame = btFrame;
        button.titleLabel.font = [UIFont systemFontOfSize:56.0];
        [cell2 addSubview:button];
        /**
         *  set cell title label
         */
        cell2.titleLabel.text=[tableData objectAtIndex:0];
        /**
         *  reset all labels and force a new painting
         */
        [self resetLabels:cell2];
        [self setBoxes:cell2];
        return cell2;
    }

    if(indexPath.row==1){
        /**
         *  init HighLowCell for blood sugar at row 1
         */
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        /**
         *  set title Label
         */
        cell.titleLabel.text=[tableData objectAtIndex:1];
        /**
         *  set text and color of value and date label
         */
        cell.highValueLabel.text=[[blutzuckerValues lastObject]valueForKey:@"value"];
        cell.lowValueLabel.text=[[blutzuckerValues firstObject]valueForKey:@"value"];
        cell.highValueLabel.textColor=[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.lowValueLabel.textColor=[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.meanLabel.textColor=[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.meanLabel.text=[self getBzMean];
        cell.meanLabel.textAlignment=UITextAlignmentCenter;
        cell.lowDateLabel.text=[dateFormat stringFromDate:[[blutzuckerValues firstObject]valueForKey:@"date"]];
        cell.highDateLabel.text=[dateFormat stringFromDate:[[blutzuckerValues lastObject]valueForKey:@"date"]];
    }
    if(indexPath.row==2){
        /**
         *  init HighLowCell for blood pressure at row 2
         */
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        /**
         *  set title Label
         */
        cell.titleLabel.text=[tableData objectAtIndex:2];
        /**
         *  set text and color of value and date label
         */
        cell.highValueLabel.text=[[[[blutdruckValues lastObject]valueForKey:@"sys"]stringByAppendingString:@"/"]stringByAppendingString:[[blutdruckValues lastObject]valueForKey:@"dia"]];
        cell.lowValueLabel.text=[[[[blutdruckValues firstObject]valueForKey:@"sys"]stringByAppendingString:@"/"]stringByAppendingString:[[blutdruckValues firstObject]valueForKey:@"dia"]];
        cell.highValueLabel.textColor=[UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        cell.lowValueLabel.textColor=[UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        cell.lowDateLabel.text=[dateFormat stringFromDate:[[blutdruckValues firstObject]valueForKey:@"date"]];
        cell.highDateLabel.text=[dateFormat stringFromDate:[[blutdruckValues lastObject]valueForKey:@"date"]];
        cell.meanLabel.text = @"";
    }
    if(indexPath.row==3){
        /**
         *  init HighLowCell for pulse at row 3
         */
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        /**
         *  set title Label
         */
        cell.titleLabel.text=[tableData objectAtIndex:3];
        /**
         *  set text and color of value and date label
         */
        cell.highValueLabel.text=[[pulsValues lastObject]valueForKey:@"value"];
        cell.lowValueLabel.text=[[pulsValues firstObject]valueForKey:@"value"];
        cell.highValueLabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.lowValueLabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.lowDateLabel.text=[dateFormat stringFromDate:[[pulsValues firstObject]valueForKey:@"date"]];
        cell.highDateLabel.text=[dateFormat stringFromDate:[[pulsValues lastObject]valueForKey:@"date"]];
        cell.meanLabel.text = @"";
    }
    return cell;
    
}
/**
 *  set height for specific row at indexpath
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return CGFloat
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
/**
 *  set action for the add value button - start AddValueController
 *
 *  @param sender
 */
- (IBAction) buttonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:@"addValueSegue" sender:self];
}
/**
 *  set action for the info button
 *
 *  @param sender
 */
- (IBAction) showInfo:(id)sender {
    [self performSegueWithIdentifier:@"infoSegue" sender:self];
}
/**
 *  set action for export button
 *
 *  @param sender
 */
- (IBAction) exportData:(id)sender {
    [self performSegueWithIdentifier:@"exportSegue" sender:self];
}
/**
 *  reset the color of all labels in the measure cell.
 *
 *  @param measureCell
 */
- (void)resetLabels:(MeasureCell *)measureCell {
    for (UILabel *label in measureCell.day1Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *label in measureCell.day2Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *label in measureCell.day3Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *label in measureCell.day4Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *label in measureCell.day5Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *label in measureCell.day6Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    for (UILabel *label in measureCell.day7Labels){
        [label setBackgroundColor:[UIColor whiteColor]];
    }
    
}
/**
 *  set all date labels in the measure cell (today and last 6 days)
 *
 *  @param measureCell <#measureCell description#>
 */
- (void)setDates:(MeasureCell *)measureCell {
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    [measureCell.day7Labels.firstObject setText:[dateFormat stringFromDate:today]];
    [measureCell.day6Labels.firstObject setText:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-1*24*60*60]]];
    [measureCell.day5Labels.firstObject setText:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-2*24*60*60]]];
    [measureCell.day4Labels.firstObject setText:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-3*24*60*60]]];
    [measureCell.day3Labels.firstObject setText:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-4*24*60*60]]];
    [measureCell.day2Labels.firstObject setText:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-5*24*60*60]]];
    [measureCell.day1Labels.firstObject setText:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-6*24*60*60]]];
}
/**
 *  paint boxes in measure cell green and red based on the maxValue and minValue variables specified in viewDidLoad method
 *
 *  @param measureCell
 */
- (void)setBoxes:(MeasureCell *)measureCell {
    /**
     *  set the date labels
     */
    [self setDates:measureCell];
    /**
     *  specify dateFormat
     */
     NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    /**
     *  set max min values, if specified in settings
     */
    if([[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]length]>0){
        minValue= [[[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]substringToIndex:3]floatValue];
        maxValue = [[[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]substringWithRange:NSMakeRange(4, 3)]floatValue];
    }
    if(maxValue<minValue){
        float temp = minValue;
        minValue = maxValue;
        maxValue=temp;
    }
    /**
     *  sort descriptor: ascending date
     */
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    /**
     *  fetch blood sugar values and sort the result
     */
    NSArray *sortedBlutzucker = [blutzuckerValues sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    /**
     *  helpful counter variables
     */
    int count=1;
    int count1=1;
    int count2=1;
    int count3=1;
    int count4=1;
    int count5=1;
    int count6=1;
    /**
     *  set labels for every day in the measure cell
     */
    for (NSManagedObject *obj in sortedBlutzucker) {
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:today]]&&count<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day7Labels objectAtIndex:count]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day7Labels objectAtIndex:count]setBackgroundColor:[UIColor redColor]];
            }
            count++;
        }
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-1*24*60*60]]]&&count1<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day6Labels objectAtIndex:count1]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day6Labels objectAtIndex:count1]setBackgroundColor:[UIColor redColor]];
            }
            count1++;
        }
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-2*24*60*60]]]&&count2<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day5Labels objectAtIndex:count2]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day5Labels objectAtIndex:count2]setBackgroundColor:[UIColor redColor]];
            }
            count2++;
        }
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-3*24*60*60]]]&&count3<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day4Labels objectAtIndex:count3]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day4Labels objectAtIndex:count3]setBackgroundColor:[UIColor redColor]];
            }
            count3++;
        }
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-4*24*60*60]]]&&count4<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day3Labels objectAtIndex:count4]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day3Labels objectAtIndex:count4]setBackgroundColor:[UIColor redColor]];
            }
            count4++;
        }
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-5*24*60*60]]]&&count5<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day2Labels objectAtIndex:count5]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day2Labels objectAtIndex:count5]setBackgroundColor:[UIColor redColor]];
            }
            count5++;
        }
        if([[dateFormat stringFromDate:[obj valueForKey:@"date"]]isEqualToString:[dateFormat stringFromDate:[today dateByAddingTimeInterval:-6*24*60*60]]]&&count6<7){
            if([[obj valueForKey:@"value"]floatValue]<maxValue && [[obj valueForKey:@"value"]floatValue]>minValue){
                [[measureCell.day1Labels objectAtIndex:count6]setBackgroundColor:[UIColor greenColor]];
            }else{
                [[measureCell.day1Labels objectAtIndex:count6]setBackgroundColor:[UIColor redColor]];
            }
            count6++;
        }

    }
}
/**
 *  get todays date
 *
 *  @return NSDate
 */
- (NSDate *)getToday{
    NSDate *today = [NSDate date];
    return today;
}
/**
 *  get todays date minus one week
 *
 *  @return NSDate
 */
- (NSDate *)getTodayMinusOneWeek{
    NSDate *today = [NSDate date];
    return [today dateByAddingTimeInterval:-6*24*60*60];
}
/**
 *  calculates the blood sugar mean and returns it as a string
 *
 *  @return NSString mean
 */
- (NSString *)getBzMean{
    double sum=0;
    for (int i=0; i<self.blutzuckerValues.count; i++) {
        sum+=[[[self.blutzuckerValues objectAtIndex:i]valueForKey:@"value"]doubleValue];
    }
    if(sum!=0){
        double mean = sum / blutzuckerValues.count/1.0f;
        NSString *meanString = [@"Ø " stringByAppendingString:[NSString stringWithFormat:@"%.1f",mean]];
        return meanString;
    }else{
        return @"";
    }
}
/**
 *  fetch data from object model
 */
-(void)performFetches{
    // read blood sugar values
    NSFetchRequest *fetchRequestBlutzucker = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    // predicate to get week data
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [self getTodayMinusOneWeek], [self getToday]];
    [fetchRequestBlutzucker setPredicate:predicate];
    [fetchRequestBlutzucker setEntity:entity];
        NSError *error;
    NSArray *sortedArray1 = [[managedObjectContext executeFetchRequest:fetchRequestBlutzucker error:&error] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[[obj1 valueForKey:@"value"]floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[[obj2 valueForKey:@"value"]floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    self.blutzuckerValues = [sortedArray1 mutableCopy];
    
    // read pulse values
    NSFetchRequest *fetchRequestPuls = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Puls" inManagedObjectContext:managedObjectContext];
    [fetchRequestPuls setPredicate:predicate];
    [fetchRequestPuls setEntity:entity];
    NSArray *sortedArray = [[managedObjectContext executeFetchRequest:fetchRequestPuls error:&error] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[[obj1 valueForKey:@"value"]floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[[obj2 valueForKey:@"value"]floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    self.pulsValues = [sortedArray mutableCopy];
    
    // read blood pressure values
    NSFetchRequest *fetchRequestBlutdruck = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Blutdruck" inManagedObjectContext:managedObjectContext];
    [fetchRequestBlutdruck setPredicate:predicate];
    [fetchRequestBlutdruck setEntity:entity];
    NSArray *sortedArray2 = [[managedObjectContext executeFetchRequest:fetchRequestBlutdruck error:&error] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[[obj1 valueForKey:@"sys"]floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[[obj2 valueForKey:@"sys"]floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    self.blutdruckValues = [sortedArray2 mutableCopy];
    
    // read settings
    NSFetchRequest *fetchRequestSettings = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Werteeinstellungen" inManagedObjectContext:managedObjectContext];
    [fetchRequestSettings setEntity:entity];
    self.werteEinstellungen = [managedObjectContext executeFetchRequest:fetchRequestSettings error:&error];
}

@end
