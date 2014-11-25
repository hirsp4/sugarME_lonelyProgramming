//
//  AddValueController.h
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddValueController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *blutdruckView;
@property (weak, nonatomic) IBOutlet UIView *pulsView;
@property (weak, nonatomic) IBOutlet UIView *blutzuckerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (IBAction)segmentedValueChanged:(id)sender;
- (IBAction)saveBlutzucker:(id)sender;
- (IBAction)saveBlutdruck:(id)sender;
- (IBAction)savePuls:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *bloodpressurePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *pulsPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *bloodsugarPickerView;

@end
