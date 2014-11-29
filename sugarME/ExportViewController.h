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
#define kPadding 40
#define kGraphHeight 280
#define kDefaultGraphWidth 300
#define kOffsetX 200
#define kStepX 30
#define kGraphBottom 280
#define kGraphTop 0
#define kStepY 15
#define kOffsetY 300
#define kCircleRadius 1.3
#define dangerousHighValue 15
#define dangerousLowValue 2
#define normalHighValue 5.7
#define normalLowValue 3.5

@interface ExportViewController : UIViewController <ReaderViewControllerDelegate>
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSMutableArray *blutzuckerValues, *pulsValues, *blutdruckValues;
@property (nonatomic, strong) NSArray *profil;
@property (nonatomic, strong) MFMailComposeViewController *globalMailComposer;

- (IBAction)generatePDF:(id)sender;
- (IBAction)setGraphOnOff:(id)sender;


@property (weak, nonatomic) IBOutlet UISwitch *blutdruckSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *blutzuckerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pulsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *graphSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *profileSwitch;


@end
