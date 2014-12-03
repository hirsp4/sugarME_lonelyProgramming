//
//  AppDelegate.m
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate
/**
 *  An instance of NSManagedObjectContext represents a single “object space” or scratch pad in an application. Its primary responsibility is to manage a collection of managed objects. These objects form a group of related model objects that represent an internally consistent view of one or more persistent stores. A single managed object instance exists in one and only one context, but multiple copies of an object can exist in different contexts. Thus object uniquing is scoped to a particular context. 
 */
@synthesize managedObjectContext = _managedObjectContext;
@synthesize globalMailComposer = _globalMailComposer;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize werteEinstellungen, bzWerte, bdWerte, pulsWerte,hba1cWerte, hba1cEinstellungen;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    sleep(1);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self checkForReminder];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Core Data stack


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "bfh.sdd" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sugarmeDB" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sugarmeDB.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
-(void)cycleTheGlobalMailComposer
{
    // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
    self.globalMailComposer = nil;
    self.globalMailComposer = [[MFMailComposeViewController alloc] init];
}

-(void)checkForReminder
{
    [self performFetches];
    BOOL assertion = false;
    NSString *alertMessage = @"\nSie sollten noch folgende Messungen durchführen: \n\n";
    alertMessage=[alertMessage stringByAppendingString:@"Heute:\n"];
    if([[[self.werteEinstellungen lastObject]valueForKey:@"bzerinnerung"]boolValue]){
       int bzMessungenSOLL = [[[self.werteEinstellungen lastObject]valueForKey:@"bzmessungen"]integerValue];
        if(bzMessungenSOLL==0){
            return;
        }
        int bzMessungenIST = self.bzWerte.count;

        if(bzMessungenIST<bzMessungenSOLL){
            assertion=true;
            alertMessage=[alertMessage stringByAppendingString:[NSString stringWithFormat:@"%d",(bzMessungenSOLL-bzMessungenIST)]];
            alertMessage=[alertMessage stringByAppendingString:@" mal Blutzucker\n"];
        }
    }
    if([[[self.werteEinstellungen lastObject]valueForKey:@"pulserinnerung"]boolValue]){
        int pulsMessungenSOLL = [[[self.werteEinstellungen lastObject]valueForKey:@"pulsmessungen"]integerValue];
        if(pulsMessungenSOLL==0){
            return;
        }
        int bdMessungenIST = self.bdWerte.count;
        int pulsMessungenIST = self.pulsWerte.count;
        if(bdMessungenIST<pulsMessungenSOLL){
            assertion=true;
            alertMessage=[alertMessage stringByAppendingString:[NSString stringWithFormat:@"%d",(pulsMessungenSOLL-bdMessungenIST)]];
            alertMessage=[alertMessage stringByAppendingString:@" mal Blutdruck\n"];
        }

        if(pulsMessungenIST<pulsMessungenSOLL){
            assertion=true;
            alertMessage=[alertMessage stringByAppendingString:[NSString stringWithFormat:@"%d",(pulsMessungenSOLL-pulsMessungenIST)]];
            alertMessage=[alertMessage stringByAppendingString:@" mal Puls\n"];
        }

    }
    if([[[self.hba1cEinstellungen lastObject]valueForKey:@"erinnerung"]boolValue]){
        int hba1cMessungenSOLL = [[[self.hba1cEinstellungen lastObject]valueForKey:@"messungen"]integerValue];
        if(hba1cMessungenSOLL==0){
            return;
        }
        int hba1cMessungenIST = self.hba1cWerte.count;
        if(hba1cMessungenIST<hba1cMessungenSOLL){
            assertion=true;
            alertMessage=[alertMessage stringByAppendingString:@"\nIn diesem Jahr:\n"];
            alertMessage=[alertMessage stringByAppendingString:[NSString stringWithFormat:@"%d",(hba1cMessungenSOLL-hba1cMessungenIST)]];
            alertMessage=[alertMessage stringByAppendingString:@" mal HbA1c\n"];
        }
    }
    if(assertion)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Erinnerung!"
                                                      message:alertMessage
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [message show];
    }
    

}

-(NSDate *)getTodayZero
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

-(NSDate *)getTodayMidnight
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    
    // Set the time components manually
    [dateComps setHour:23];
    [dateComps setMinute:59];
    [dateComps setSecond:59];
    
    // Convert back
    NSDate *endOfDay = [calendar dateFromComponents:dateComps];
    return endOfDay;
    
}

-(NSDate *)getStartOfYear
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    
    // Set the time components manually
    [dateComps setMonth:1];
    [dateComps setDay:1];
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *yearStart = [calendar dateFromComponents:dateComps];
    return yearStart;
    
}



-(void)performFetches
{
    // einstellungen lesen
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Werteeinstellungen" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.werteEinstellungen = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    // einstellungen lesen
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity1 = [NSEntityDescription
                                   entityForName:@"HbA1cEinstellungen" inManagedObjectContext:_managedObjectContext];
    [fetchRequest1 setEntity:entity1];
    self.hba1cEinstellungen = [_managedObjectContext executeFetchRequest:fetchRequest1 error:&error];
    // set predicate for today
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [self getTodayZero], [self getTodayMidnight]];
    // blutzucker daten lesen
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:_managedObjectContext];
    [fetchRequest2 setEntity:entity2];
    [fetchRequest2 setPredicate:predicate];
    self.bzWerte = [_managedObjectContext executeFetchRequest:fetchRequest2 error:&error];
    
    // blutdruck daten lesen
    NSFetchRequest *fetchRequest3 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity3 = [NSEntityDescription
                                   entityForName:@"Blutdruck" inManagedObjectContext:_managedObjectContext];
    [fetchRequest3 setEntity:entity3];
    [fetchRequest3 setPredicate:predicate];
    self.bdWerte = [_managedObjectContext executeFetchRequest:fetchRequest3 error:&error];
    
    // puls daten lesen
    NSFetchRequest *fetchRequest4 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity4 = [NSEntityDescription
                                   entityForName:@"Puls" inManagedObjectContext:_managedObjectContext];
    [fetchRequest4 setEntity:entity4];
    [fetchRequest4 setPredicate:predicate];
    self.pulsWerte = [_managedObjectContext executeFetchRequest:fetchRequest4 error:&error];
    
    // hba1c daten lesen
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"date >= %@", [self getStartOfYear]];
    NSFetchRequest *fetchRequest5 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity5 = [NSEntityDescription
                                    entityForName:@"HbA1c" inManagedObjectContext:_managedObjectContext];
    [fetchRequest5 setEntity:entity5];
    [fetchRequest5 setPredicate:predicate2];
    self.hba1cWerte = [_managedObjectContext executeFetchRequest:fetchRequest5 error:&error];
    
}



@end
