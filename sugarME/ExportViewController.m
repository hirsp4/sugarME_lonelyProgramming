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
#import "GraphView.h"


@interface ExportViewController (){
    CGSize _pageSize;
}

@end

@implementation ExportViewController
@synthesize blutzuckerValues, managedObjectContext, pulsValues, blutdruckValues,globalMailComposer;

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    self.globalMailComposer =[appDelegate globalMailComposer];
    // Do any additional setup after loading the view.
    [self performFetches];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)generatePDF:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm:ss"];
    // generate PDF
    [self setupPDFDocumentNamed:@"NewPDF" Width:850 Height:1100];
    [self beginPDFPage];
    NSDate *today =[NSDate date];
    NSString *title =@"sugarME - Verlaufsdokumentation";
    NSString *header = [[title stringByAppendingString:@"                                    "]stringByAppendingString:[dateFormat stringFromDate:today]];
    CGRect textRect = [self addTitleText:header
                          withFrame:CGRectMake(kPadding, kPadding, 400, 100) fontSize:22.0f];
    
    
    GraphView *graphView = [[GraphView alloc]init];
    UIGraphicsBeginImageContext(graphView.bounds.size);
    [graphView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    CGRect blackLine = [self addLineWithFrame:CGRectMake(kPadding, textRect.origin.y + textRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                                       withColor:[UIColor blackColor]];
    CGRect imageRect = [self addImage:anImage
                              atPoint:CGPointMake((_pageSize.width/2)-(anImage.size.width/2), blackLine.origin.y + blackLine.size.height+ kPadding)];
    // start content: blutzucker
    [self addValueText:@"Blutzuckerwerte in mmol/l"
             withFrame:CGRectMake(kPadding, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<blutzuckerValues.count;i++){
        NSString *value= [[blutzuckerValues objectAtIndex:i]valueForKey:@"value"];
        NSString *date= [dateFormat stringFromDate:[[blutzuckerValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                                   withFrame:CGRectMake(kPadding, kPadding+90+((i+1)*15), 200, 100) fontSize:14.0f];
    }
    // blutdruck
    [self addValueText:@"Blutdruckwerte in mmHG"
             withFrame:CGRectMake(kPadding+300, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<blutdruckValues.count;i++){
        NSString *value1= [[blutdruckValues objectAtIndex:i]valueForKey:@"sys"];
        NSString *value2= [[blutdruckValues objectAtIndex:i]valueForKey:@"dia"];
        NSString *value= [[value1 stringByAppendingString:@"/"]stringByAppendingString:value2];
        NSString *date= [dateFormat stringFromDate:[[blutdruckValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                 withFrame:CGRectMake(kPadding+300, kPadding+90+((i+1)*15), 400, 100) fontSize:14.0f];
    }
    // puls
    [self addValueText:@"Pulswerte in s/min"
             withFrame:CGRectMake(kPadding+600, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<pulsValues.count;i++){
        NSString *value= [[pulsValues objectAtIndex:i]valueForKey:@"value"];
        NSString *date= [dateFormat stringFromDate:[[pulsValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                 withFrame:CGRectMake(kPadding+600, kPadding+90+((i+1)*15), 600, 100) fontSize:14.0f];
    }
    
    [self addLineWithFrame:CGRectMake(kPadding, 1000, _pageSize.width - kPadding*2, 4)
                                    withColor:[UIColor blackColor]];
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
- (CGRect)addTitleText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
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

- (CGRect)addValueText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize {
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
    CGContextSetLineWidth(currentContext,2);
    
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

-(void)performFetches{
    // Blutzucker Daten lesen.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.blutzuckerValues = [self sortArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    //Puls Daten lesen.
    entity = [NSEntityDescription
                                   entityForName:@"Puls" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.pulsValues = [self sortArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
    
    //Blutdruck Daten lesen.
    entity = [NSEntityDescription
              entityForName:@"Blutdruck" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.blutdruckValues = [self sortArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
}

-(NSArray *)sortArray:(NSArray*)arr{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    return [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
}

@end
