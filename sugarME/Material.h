//
//  Material.h
//  sugarME
//
//  Created by Fresh Prince on 13.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Material : NSManagedObject
@property NSData *image;
@property NSString *name;
@end