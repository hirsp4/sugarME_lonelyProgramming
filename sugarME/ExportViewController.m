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
@synthesize blutzuckerValues, managedObjectContext, pulsValues, blutdruckValues,globalMailComposer, blutdruckSwitch, blutzuckerSwitch, pulsSwitch, graphSwitch,profil,profileSwitch, werteEinstellungen;

/**
 *  actions after loading the view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // get the managedobjectcontext of the AppDelegate (to fetch data)
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
/**
 *  setup the pdf document
 *
 *  @param sender
 */
- (IBAction)generatePDF:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm:ss"];
    // generate PDF
    [self setupPDFDocumentNamed:@"Verlaufsdokumentation" Width:850 Height:1100];
    [self beginPDFPage];
    //set Header
    NSDate *today =[NSDate date];
    NSString *title =@"sugarME - Verlaufsdokumentation";
    NSString *header = [[title stringByAppendingString:@"                               "]stringByAppendingString:[dateFormat stringFromDate:today]];
    CGRect textRect = [self addTitleText:header
                          withFrame:CGRectMake(kPadding, kPadding, 400, 100) fontSize:22.0f];
    // top horicontal line
    [self addLineWithFrame:CGRectMake(kPadding, textRect.origin.y + textRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                                       withColor:[UIColor blackColor]];
    // bottom horicontal line
    [self addLineWithFrame:CGRectMake(kPadding, 1000, _pageSize.width - kPadding*2, 4)
                                    withColor:[UIColor blackColor]];
    // draw content
    if([profileSwitch isOn]){
        if(profil.count!=0){
       [self drawProfileValues];
        }
    }
    
    if([blutdruckSwitch isOn]){
       [self drawBlutdruckValues];
    }
    if([pulsSwitch isOn]){
        if([blutzuckerSwitch isOn]&&[blutdruckSwitch isOn]){
            [self drawPulsValues:570];
        }
        if((![blutzuckerSwitch isOn])&&(![blutdruckSwitch isOn])){
            [self drawPulsValues:0];
        }
        if([blutzuckerSwitch isOn]&&(![blutdruckSwitch isOn])){
            [self drawPulsValues:0];
        }
        if((![blutzuckerSwitch isOn])&&[blutdruckSwitch isOn]){
            [self drawPulsValues:285];
        }
    }
    if([blutzuckerSwitch isOn]){
        [self drawBlutzuckerValues];
        if([graphSwitch isOn]){
            [self drawGraph];
        }
    }
    
    [self finishPDF];
    
///////////////////////////////////////////
    
    //open PDF
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"Verlaufsdokumentation.pdf"];
    
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
/**
 *  graph can only be set ON if blood sugar values are set on
 *
 *  @param sender
 */
- (IBAction)setGraphOnOff:(id)sender {
    if(![sender isOn]){
        [graphSwitch setOn:NO];
    }else{
       [graphSwitch setOn:YES];
    }
}

/**
 *  setup an empty pdf document in the documents directory of the app
 *
 *  @param name   name
 *  @param width  width
 *  @param height height
 */
- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}
/**
 *  begin PDF document
 */
- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0,_pageSize.width,_pageSize.height), nil);
}
/**
 *  pdf document title text (Arial Bold)
 *
 *  @param text
 *  @param frame
 *  @param fontSize
 *
 *  @return CGRect
 */
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
/**
 *  pdf document value text
 *
 *  @param text
 *  @param frame
 *  @param fontSize
 *
 *  @return CGRect
 */
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


/**
 *  add a line to pdf document
 *
 *  @param frame
 *  @param color
 *
 *  @return CGRect
 */
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

/**
 *  finish the pdf document
 */
- (void)finishPDF {
    UIGraphicsEndPDFContext();
}
/**
 *  dismiss the viewcontroller
 *
 *  @param viewController
 */
- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
}
/**
 *  fetch all needed data for the building of the pdf document from the managed object model
 */
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
    
    //Profil Daten lesen.
    entity = [NSEntityDescription
                                   entityForName:@"Profil" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.profil =[managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Einstellungen Daten lesen.
    entity = [NSEntityDescription
              entityForName:@"Werteeinstellungen" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    self.werteEinstellungen =[managedObjectContext executeFetchRequest:fetchRequest error:&error];


}
/**
 *  sort the input array (date ascending)
 *
 *  @param arr
 *
 *  @return NSArray
 */
-(NSArray *)sortArray:(NSArray*)arr{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    return [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];;
}
/**
 *  draw the blood sugar line graph
 *
 *  @param ctx
 */
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
/**
 *  draw the coordinate system and all bordervalues
 */
-(void)drawGraph{
    // graph
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    //graph legende zeichnen
    float maxValue=5.6f;
    float minValue=3.5f;
    if([[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]length]>0){
        minValue= [[[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]substringToIndex:3]floatValue];
        maxValue = [[[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]substringWithRange:NSMakeRange(4, 3)]floatValue];
    }
    if(maxValue<minValue){
        float temp = minValue;
        minValue = maxValue;
        maxValue=temp;
    }
    
    [self addValueText:@"Begrenzungen in mmol/l: "
             withFrame:CGRectMake(kPadding, kPadding+375, 100, 100) fontSize:14.0f];
    [self addValueText:[@"Rote Obergrenze: " stringByAppendingString:@"15.0"]
             withFrame:CGRectMake(kPadding, kPadding+400, 100, 100) fontSize:14.0f];
    [self addValueText:[@"Grüne Obergrenze: " stringByAppendingString:[NSString stringWithFormat:@"%.1f", maxValue]]
             withFrame:CGRectMake(kPadding, kPadding+415, 100, 100) fontSize:14.0f];
    [self addValueText:[@"Grüne Untergrenze: " stringByAppendingString:[NSString stringWithFormat:@"%.1f", minValue]]
             withFrame:CGRectMake(kPadding, kPadding+430, 100, 100) fontSize:14.0f];
    [self addValueText:[@"Rote Untergrenze: " stringByAppendingString:@"2.0"]
             withFrame:CGRectMake(kPadding, kPadding+445, 100, 100) fontSize:14.0f];
    // graph zeichnen
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context,270,370);
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
    // draw border values
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
}
/**
 *  draw the profile data specified in the app (personalize the pdf document)
 */
-(void)drawProfileValues{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm:ss"];
    // Profildaten
    [self addTitleText:@"Angaben zur Person"
             withFrame:CGRectMake(kPadding+560, kPadding+775, 200, 100) fontSize:16.0f];
    [self addValueText:[@"Vorname:            " stringByAppendingString:[[profil lastObject]valueForKey:@"vorname"]]
                 withFrame:CGRectMake(kPadding+560, kPadding+790+1*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Nachname:         " stringByAppendingString:[[profil lastObject]valueForKey:@"nachname"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+2*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Geschlecht:        " stringByAppendingString:[[profil lastObject]valueForKey:@"geschlecht"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+3*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Geburtsdatum:   " stringByAppendingString:[[profil lastObject]valueForKey:@"geburtsdatum"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+4*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Grösse:               " stringByAppendingString:[[profil lastObject]valueForKey:@"groesse"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+5*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Gewicht:             " stringByAppendingString:[[profil lastObject]valueForKey:@"gewicht"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+6*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Diabetestyp:       " stringByAppendingString:[[profil lastObject]valueForKey:@"typ"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+7*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"Diagnosejahr:      " stringByAppendingString:[[profil lastObject]valueForKey:@"diagnosejahr"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+8*15, 400, 100) fontSize:14.0f];
    [self addValueText:[@"E-Mail:                " stringByAppendingString:[[profil lastObject]valueForKey:@"email"]]
             withFrame:CGRectMake(kPadding+560, kPadding+790+9*15, 400, 100) fontSize:14.0f];
}
/**
 *  draw the last 10 added blood sugar values
 */
-(void)drawBlutzuckerValues{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm:ss"];
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

    
}
/**
 *   draw the last 10 added blood pressure values
 */
-(void)drawBlutdruckValues{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm:ss"];
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

    
}
/**
 *   draw the last 10 added pulse values
 *
 *  @param int1
 */
-(void)drawPulsValues:(CGFloat)int1{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yyyy - HH:mm:ss"];
    // puls
    [self addTitleText:@"Pulswerte in s/min"
             withFrame:CGRectMake(kPadding+int1, kPadding+75, 200, 100) fontSize:16.0f];
    for(int i=0; i<pulsValues.count;i++){
        NSString *value= [[pulsValues objectAtIndex:i]valueForKey:@"value"];
        NSString *date= [dateFormat stringFromDate:[[pulsValues objectAtIndex:i]valueForKey:@"date"]];
        NSString *combined = [[date stringByAppendingString:@"          "]stringByAppendingString:value];
        [self addValueText:combined
                 withFrame:CGRectMake(kPadding+int1, kPadding+90+((i+1)*15), 600, 100) fontSize:14.0f];
    }
}


@end
