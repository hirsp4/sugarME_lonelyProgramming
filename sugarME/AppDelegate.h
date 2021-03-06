//
//  AppDelegate.h
//  sugarME
//
//  Created by Fresh Prince on 30.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;
@property (nonatomic, strong) NSArray *werteEinstellungen;
@property (nonatomic, strong) NSArray *hba1cEinstellungen;
@property (nonatomic, strong) NSArray *bzWerte;
@property (nonatomic, strong) NSArray *pulsWerte;
@property (nonatomic, strong) NSArray *bdWerte;
@property (nonatomic, strong) NSArray *hba1cWerte;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

