//
//  Profil.h
//  sugarME
//
//  Created by Fresh Prince on 29.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Profil : NSManagedObject
@property NSString *vorname;
@property NSString *nachname;
@property NSString *email;
@property NSString *geschlecht;
@property NSString *geburtsdatum;
@property NSString *groesse;
@property NSString *gewicht;
@property NSString *typ;
@property NSString *diagnosejahr;
@end
