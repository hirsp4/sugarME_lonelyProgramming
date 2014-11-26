//
//  ExportViewController.m
//  sugarME
//
//  Created by Fresh Prince on 31.10.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "ExportViewController.h"
#import "AppDelegate.h"
#import "FirstViewController.h"


@interface ExportViewController (){
    CGSize _pageSize;
}

@end

@implementation ExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Senden" style:UIBarButtonItemStylePlain target:self action:@selector(sendData:)];
    self.navigationItem.rightBarButtonItem = sendButton;
    [self cycleTheGlobalMailComposer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) sendData:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Diabetes Daten";
    // Email Content
    NSString *messageBody = @"Wow, so viele Daten!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"shabf2@bfh.ch"];
    
    self.globalMailComposer.mailComposeDelegate = self;
    [self.globalMailComposer setSubject:emailTitle];
    [self.globalMailComposer setMessageBody:messageBody isHTML:NO];
    [self.globalMailComposer setToRecipients:toRecipents];
    
    
    // Present mail view controller on screen
    [self presentViewController:self.globalMailComposer animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }

    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:^
     { [self cycleTheGlobalMailComposer]; }
     ];
}

-(void)cycleTheGlobalMailComposer
         {
             // we are cycling the damned GlobalMailComposer... due to horrible iOS issue
             self.globalMailComposer = nil;
             self.globalMailComposer = [[MFMailComposeViewController alloc] init];
         }
- (IBAction)generatePDF:(id)sender {
    // generate PDF
    [self setupPDFDocumentNamed:@"NewPDF" Width:850 Height:1100];
    [self beginPDFPage];
    CGRect textRect = [self addText:@"sugarME - Verlaufsdokumentation"
                          withFrame:CGRectMake(kPadding, kPadding, 400, 100) fontSize:20.0f];
    UIImage *anImage = [UIImage imageNamed:@"tree.jpg"];
    CGRect blueLineRect = [self addLineWithFrame:CGRectMake(kPadding, textRect.origin.y + textRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                                       withColor:[UIColor blueColor]];
    CGRect imageRect = [self addImage:anImage
                              atPoint:CGPointMake((_pageSize.width/2)-(anImage.size.width/2), blueLineRect.origin.y + blueLineRect.size.height+ kPadding)];
    [self addLineWithFrame:CGRectMake(kPadding, imageRect.origin.y +imageRect.size.height + kPadding,_pageSize.width - kPadding*2, 4)
                 withColor:[UIColor redColor]];
    [self finishPDF];
    
    
    
    //open PDF
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"NewPDF.pdf"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentModalViewController:readerViewController animated:YES];
        }
    }

}


- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}
- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0,_pageSize.width,_pageSize.height), nil);
}
- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20) lineBreakMode:UILineBreakModeWordWrap];
    
    float textWidth =frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect
            withFont:font
       lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    return frame;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    CGContextSetLineWidth(currentContext,frame.size.height);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width,image.size.height);
    [image drawInRect:imageFrame];
    return imageFrame;
}
- (void)finishPDF {
    UIGraphicsEndPDFContext();
}
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}
@end
