//
//  Puls.h
//  sugarME
//
//  Created by Fresh Prince on 02.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Puls : NSManagedObject
@property NSDate *date;
@property NSString *value;
@property NSString *type;
@end
