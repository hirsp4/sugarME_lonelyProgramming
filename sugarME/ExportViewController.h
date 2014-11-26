//
//  ExportViewController.h
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ReaderViewController.h"
#define kPadding 20
@interface ExportViewController : UIViewController <ReaderViewControllerDelegate>
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *blutzuckerValues, *pulsValues, *blutdruckValues;
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

- (IBAction)generatePDF:(id)sender;

@end
