//
//  AddMaterialViewController.h
//  sugarME
//
//  Created by Fresh Prince on 16.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMaterialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *materialText;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
- (IBAction)saveMaterial:(id)sender;
@end
