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

@implementation FirstViewController{
    NSArray *tableData;
    float maxValue;
    float minValue;
}
@synthesize tableWerte=_tableWerte;
@synthesize blutzuckerValues, managedObjectContext, pulsValues, blutdruckValues;
- (void)viewDidLoad {
    [super viewDidLoad];
    minValue = 3.5f;
    maxValue = 5.7f;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    // Do any additional setup after loading the view, typically from a nib.
    tableData = [NSArray arrayWithObjects:@"Blutzuckermessungen",@"Blutzucker Werte dieser Woche", @"Blutdruck Werte dieser Woche", @"Puls Werte dieser Woche", nil];
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(showInfo:)];
     UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportData:)];
    self.navigationItem.rightBarButtonItem = infoButton;
    self.navigationItem.leftBarButtonItem = exportButton;
    [self performFetches];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [self performFetches];
    NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
    NSIndexPath* indexPath3 = [NSIndexPath indexPathForRow:3 inSection:0];
    NSIndexPath* indexPath4 = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray* indexArray = [NSArray arrayWithObjects:indexPath1,indexPath2,indexPath3,indexPath4, nil];
    [_tableWerte reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *highLowCellIdentifier = @"HighLowCell";
    HighLowCell *cell = (HighLowCell *)[tableView dequeueReusableCellWithIdentifier:highLowCellIdentifier];

    if(indexPath.row==0){
        UserCell *cell3 = (UserCell *)[tableView dequeueReusableCellWithIdentifier:@"UserCell"];
        if (cell3 == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCell" owner:self options:nil];
            cell3 = [nib objectAtIndex:0];
        }
        cell3.titleLabel.text=@"Faton Shabanaj";
        return cell3;
    }
    if(indexPath.row==1){
        MeasureCell *cell2 = (MeasureCell *)[tableView dequeueReusableCellWithIdentifier:@"MeasureCell"];
        if (cell2 == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeasureCell" owner:self options:nil];
            cell2 = [nib objectAtIndex:0];
        }
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
        cell2.titleLabel.text=[tableData objectAtIndex:0];
        [self resetLabels:cell2];
        [self setBoxes:cell2];
        return cell2;
    }

    if(indexPath.row==2){
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.titleLabel.text=[tableData objectAtIndex:1];
        cell.highValueLabel.text=[[blutzuckerValues lastObject]valueForKey:@"value"];
        cell.lowValueLabel.text=[[blutzuckerValues firstObject]valueForKey:@"value"];
        cell.highValueLabel.textColor=[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.lowValueLabel.textColor=[UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    }
    if(indexPath.row==3){
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.titleLabel.text=[tableData objectAtIndex:2];
        cell.highValueLabel.text=[[[[blutdruckValues lastObject]valueForKey:@"sys"]stringByAppendingString:@"/"]stringByAppendingString:[[blutdruckValues lastObject]valueForKey:@"dia"]];
        cell.lowValueLabel.text=[[[[blutdruckValues firstObject]valueForKey:@"sys"]stringByAppendingString:@"/"]stringByAppendingString:[[blutdruckValues firstObject]valueForKey:@"dia"]];
        cell.highValueLabel.textColor=[UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        cell.lowValueLabel.textColor=[UIColor colorWithRed:255.0f/255.0f green:217.0f/255.0f blue:102.0f/255.0f alpha:1.0];
    }
    if(indexPath.row==4){
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HighLowCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.titleLabel.text=[tableData objectAtIndex:3];
        cell.highValueLabel.text=[[pulsValues lastObject]valueForKey:@"value"];
        cell.lowValueLabel.text=[[pulsValues firstObject]valueForKey:@"value"];
        cell.highValueLabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
        cell.lowValueLabel.textColor=[UIColor colorWithRed:153.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        return 50;
    }else if(indexPath.row>1&&indexPath.row<5){
        return 95;
    }else{
    return 110;
    }
}
- (IBAction) buttonTouchUpInside:(id)sender {
    [self performSegueWithIdentifier:@"addValueSegue" sender:self];
}
- (IBAction) showInfo:(id)sender {
    [self performSegueWithIdentifier:@"infoSegue" sender:self];
}
- (IBAction) exportData:(id)sender {
    [self performSegueWithIdentifier:@"exportSegue" sender:self];
}
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
- (void)setBoxes:(MeasureCell *)measureCell {
    [self setDates:measureCell];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedBlutzucker = [blutzuckerValues sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    int count=1;
    int count1=1;
    int count2=1;
    int count3=1;
    int count4=1;
    int count5=1;
    int count6=1;
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

- (NSDate *)getToday{
    NSDate *today = [NSDate date];
    return today;
}
- (NSDate *)getTodayMinusOneWeek{
    NSDate *today = [NSDate date];
    return [today dateByAddingTimeInterval:-6*24*60*60];
}
-(void)performFetches{
    // Blutzucker Daten lesen.
    NSFetchRequest *fetchRequestBlutzucker = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    [fetchRequestBlutzucker setEntity:entity];
        NSError *error;
    NSArray *sortedArray1 = [[managedObjectContext executeFetchRequest:fetchRequestBlutzucker error:&error] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[[obj1 valueForKey:@"value"]floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[[obj2 valueForKey:@"value"]floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    self.blutzuckerValues = [sortedArray1 mutableCopy];
    
    //Puls Daten lesen.
    NSFetchRequest *fetchRequestPuls = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Puls" inManagedObjectContext:managedObjectContext];
    [fetchRequestPuls setEntity:entity];
    NSArray *sortedArray = [[managedObjectContext executeFetchRequest:fetchRequestPuls error:&error] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[[obj1 valueForKey:@"value"]floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[[obj2 valueForKey:@"value"]floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    self.pulsValues = [sortedArray mutableCopy];
    
    //Blutdruck Daten lesen.
    NSFetchRequest *fetchRequestBlutdruck = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"Blutdruck" inManagedObjectContext:managedObjectContext];
    [fetchRequestBlutdruck setEntity:entity];
    NSArray *sortedArray2 = [[managedObjectContext executeFetchRequest:fetchRequestBlutdruck error:&error] sortedArrayUsingComparator:(NSComparator)^(id obj1, id obj2) {
        NSNumber *num1 = [NSNumber numberWithFloat:[[obj1 valueForKey:@"sys"]floatValue]];
        NSNumber *num2 = [NSNumber numberWithFloat:[[obj2 valueForKey:@"sys"]floatValue]];
        return (NSComparisonResult)[num1 compare:num2];
    }];
    self.blutdruckValues = [sortedArray2 mutableCopy];
}

@end
