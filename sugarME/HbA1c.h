//
//  HbA1c.h
//  sugarME
//
//  Created by Fresh Prince on 14.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HbA1c : NSManagedObject
@property NSDate *date;
@property NSString *value;
@end
