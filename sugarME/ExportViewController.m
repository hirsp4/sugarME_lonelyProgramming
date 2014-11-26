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
    NSString *header = [[title stringByAppendingString:@"                               "]stringByAppendingString:[dateFormat stringFromDate:today]];
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
    // start content: blutdruck
    [self addTitleText:@"Blutdruckwerte in mmHG"
             withFrame:CGRectMake(kPadding, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<blutdruckValues.count;i++){
        NSString *value1= [[blutdruckValues objectAtIndex:i]valueForKey:@"sys"];
        NSString *value2= [[blutdruckValues objectAtIndex:i]valueForKey:@"dia"];
        NSString *value= [[value1 stringByAppendingString:@"/"]stringByAppendingString:value2];
        NSString *date= [dateFormat stringFromDate:[[blutdruckValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                 withFrame:CGRectMake(kPadding, kPadding+90+((i+1)*15), 200, 100) fontSize:14.0f];
    }
    // blutzucker
    [self addTitleText:@"Blutzuckerwerte in mmol/l"
             withFrame:CGRectMake(kPadding+285, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<blutzuckerValues.count;i++){
        NSString *value= [[blutzuckerValues objectAtIndex:i]valueForKey:@"value"];
        NSString *date= [dateFormat stringFromDate:[[blutzuckerValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                 withFrame:CGRectMake(kPadding+285, kPadding+90+((i+1)*15), 400, 100) fontSize:14.0f];
    }
    // puls
    [self addTitleText:@"Pulswerte in s/min"
             withFrame:CGRectMake(kPadding+570, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<pulsValues.count;i++){
        NSString *value= [[pulsValues objectAtIndex:i]valueForKey:@"value"];
        NSString *date= [dateFormat stringFromDate:[[pulsValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                 withFrame:CGRectMake(kPadding+570, kPadding+90+((i+1)*15), 600, 100) fontSize:14.0f];
    }
    
    [self addLineWithFrame:CGRectMake(kPadding, 1000, _pageSize.width - kPadding*2, 4)
                                    withColor:[UIColor blackColor]];
    
    // graph
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context,270,400);
    [self drawLineGraphWithContext:context];
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
    }
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetLineWidth(context,1.4);
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - normalLowValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - normalLowValue * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - normalHighValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - normalHighValue * kStepY);
    CGContextStrokePath(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetLineDash(context, 0.0, NULL, 0);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - dangerousHighValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - dangerousHighValue * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - dangerousLowValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - dangerousLowValue * kStepY);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context,2.0);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextMoveToPoint(context, kOffsetX + 0 * kStepX, kGraphTop);
    CGContextAddLineToPoint(context, kOffsetX + 0 * kStepX, kGraphBottom-kOffsetX);
    
    CGContextStrokePath(context);

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
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
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
    self.blutzuckerValues = [[NSMutableArray alloc]initWithArray:[self sortArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]]];
    while(self.blutzuckerValues.count>10){
        [self.blutzuckerValues removeObjectAtIndex:0];
    }
    
    //Puls Daten lesen.
    entity = [NSEntityDescription
                                   entityForName:@"Puls" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.pulsValues = [[NSMutableArray alloc]initWithArray:[self sortArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]]];
    while(self.pulsValues.count>10){
        [self.pulsValues removeObjectAtIndex:0];
    }
    //Blutdruck Daten lesen.
    entity = [NSEntityDescription
              entityForName:@"Blutdruck" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.blutdruckValues = [[NSMutableArray alloc]initWithArray:[self sortArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]]];
    while(self.blutdruckValues.count>10){
        [self.blutdruckValues removeObjectAtIndex:0];
    }
}

-(NSArray *)sortArray:(NSArray*)arr{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    return [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];;
}
- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    // graph line
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    int maxGraphHeight = kGraphHeight - kOffsetY;
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * ([[[blutzuckerValues firstObject]valueForKey:@"value"]floatValue]/18.0f)-9);
    int i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/18.0f)-9);
        i++;
    }
    CGContextDrawPath(ctx, kCGPathStroke);
    //graph füllfarbe
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:52.0f/255.0f green:107.0f/255.0f blue:196.0f/255.0f alpha:0.9] CGColor]);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight-10);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * ([[[blutzuckerValues firstObject] valueForKey:@"value"]floatValue]/18.0f));
    i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/18.0f)-9);
        i++;
    }
    CGContextAddLineToPoint(ctx, kOffsetX + (blutzuckerValues.count - 1) * kStepX, kGraphHeight-10);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFill);
    
    // graph points
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/18.0f);
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius-9, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
        i++;
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
    // graph value labels
    CGContextSetTextMatrix(ctx, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSetTextDrawingMode(ctx, kCGTextFill);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        float x = kOffsetX + i * kStepX;
        float y = kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/18.0f);
        CGContextSelectFont(ctx, "Helvetica", 10, kCGEncodingMacRoman);
        NSString *theText = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[obj valueForKey:@"date"]]];
        CGContextShowTextAtPoint(ctx, kOffsetX -9 + i* kStepX, kGraphBottom+3, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
        CGContextSelectFont(ctx, "Helvetica-Bold", 14, kCGEncodingMacRoman);
        NSString *theText2 = [NSString stringWithFormat:@"%@", [obj valueForKey:@"value"]];
        CGContextShowTextAtPoint(ctx, x - kCircleRadius+10, y - kCircleRadius+1, [theText2 cStringUsingEncoding:NSUTF8StringEncoding], [theText2 length]);
        i++;
    }
    
    
}


@end
