//
//  FourthViewController.h
//  sugarME
//
//  Created by Maja Kelterborn on 13.11.14.
//  Copyright (c) 2014 Maja Kelterborn. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface FourthViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *materialNames;
@property (strong, nonatomic) NSString *selectedRowText;

@end


