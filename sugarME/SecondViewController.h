//
//  SecondViewController.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UITableView *tableWerte;
@property (nonatomic, strong) NSArray *blutzuckerValues;
@property (nonatomic, strong) NSArray *pulsValues;
@property (nonatomic, strong) NSArray *blutdruckValues;
@property (nonatomic, strong) NSArray *allValues;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@end

