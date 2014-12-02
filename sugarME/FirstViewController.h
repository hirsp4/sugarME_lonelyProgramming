//
//  FirstViewController.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableWerte;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *blutzuckerValues, *pulsValues, *blutdruckValues, *werteEinstellungen;

@end

