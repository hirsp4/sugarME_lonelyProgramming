//
//  AddHbA1cViewController.h
//  sugarME
//
//  Created by Fresh Prince on 14.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddHbA1cViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *hba1cText;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
- (IBAction)saveHbA1c:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *hba1cPickerView;

@end
