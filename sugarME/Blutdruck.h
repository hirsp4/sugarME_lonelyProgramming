//
//  Blutdruck.h
//  sugarME
//
//  Created by Fresh Prince on 02.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Blutdruck : NSManagedObject
@property NSDate *date;
@property NSString *dia;
@property NSString *sys;
@property NSString *type;
@end
