//
//  HbA1cEinstellungen.h
//  sugarME
//
//  Created by Fresh Prince on 29.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HbA1cEinstellungen : NSManagedObject
@property NSString *zielbereich;
@property NSString *messungen;
@property Boolean *erinnerung;
@end
