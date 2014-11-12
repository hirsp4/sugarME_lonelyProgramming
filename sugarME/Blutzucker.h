//
//  Blutzucker.h
//  sugarME
//
//  Created by Fresh Prince on 02.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface Blutzucker : NSManagedObject
@property NSString *unit;
@property NSDate *date;
@property NSString *value;
@property NSString *kommentar;
@property NSString *type;

@end
