//
//  ThirdViewController.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableWerte;
@property (weak, nonatomic) IBOutlet UIView *ampelView;

@property (nonatomic, strong) NSArray *hba1cValues;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
