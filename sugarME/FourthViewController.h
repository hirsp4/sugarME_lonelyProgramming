//
//  FourthViewController.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FourthViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *materialNames;
@property (strong, nonatomic) NSMutableArray *thumbs;

@end


