//
//  Material.h
//  sugarME
//
//  Created by Fresh Prince on 13.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Material : NSManagedObject
@property NSString *name;
@property NSString *dosis;
@property NSString *mengeSchachtel;
@property NSString *mengeAktuell;
@end
