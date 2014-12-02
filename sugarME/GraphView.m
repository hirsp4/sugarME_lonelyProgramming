//
//  GraphView.m
//  sugarME
//
//  Created by Fresh Prince on 05.11.14.
//  Copyright (c) 2014 Berner Fachhochschule. All rights reserved.
//

#import "GraphView.h"
#import "Blutzucker.h"
#import "AppDelegate.h"

@implementation GraphView
@synthesize blutzuckerValues, managedObjectContext, werteEinstellungen;

/**
 *  first draft: bar graph with the values. 
 
 *                             !!!!!!!!!!!!DEPRECATED!!!!!!!!!!!
 *
 *  @param ctx
 */
- (void)drawBarGraphWithContext:(CGContextRef)ctx
{
    float maxBarHeight = kGraphHeight - kBarTop - kOffsetY;
    int i=0;
    for (NSManagedObject *obj in blutzuckerValues)
    {
        float barX = kOffsetX + kStepX + i* kStepX - kBarWidth / 2;
        float barY = kBarTop + maxBarHeight - maxBarHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f);
        float barHeight = maxBarHeight * ([[obj valueForKey:@"value"]floatValue]/9.0f);
        
        CGRect barRect = CGRectMake(barX, barY-5, kBarWidth, barHeight+5);
        if(([[obj valueForKey:@"value"]floatValue]/1.0f)<3.5 || ([[obj valueForKey:@"value"]floatValue]/1.0f)> 5.7){
            CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        }else CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
        [self drawBar:barRect context:ctx];
        i++;
    }
    
}
/**
 *  draw a linegraph in the specified context
 *
 *  @param ctx
 */
- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    // set the date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    // graph line
    CGContextSetLineWidth(ctx, 3.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    int maxGraphHeight = kGraphHeight - kOffsetY;
    CGContextBeginPath(ctx);
    // move to the first value that has to be drawn
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * ([[[blutzuckerValues firstObject]valueForKey:@"value"]floatValue]/18.0f)-9);
    int i=0;
    // iterate through all blood sugar object and add lines from the old points to the new points
    for (NSManagedObject *obj in blutzuckerValues)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ([[obj valueForKey:@"value"]floatValue]/18.0f)-9);
        i++;
    }
    // draw the path
    CGContextDrawPath(ctx, kCGPathStroke);
    //graph füllfarbe
    // check if the array is empty, if yes: no fill color
    // if no: build a draw path around all values and the coordinate system to have a closed area for the fill color
    if(blutzuckerValues.count!=0){
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
    }
    
    
    // graph points
    // implement circles on the values
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
    // set the labels (date and value in the graph)
    /**
     *
     *
     *
     *              !!!!!!! LET THE PIXEL WAR BEGIN !!!!!!!
     *
     *
     */
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
 *  first method that is called of the view
 *
 *  @param rect
 */
- (void)drawRect:(CGRect)rect
{
    // get the managed object model for the fetches
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    [self performFetches];
    // set date format
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM"];
    // set specified max min value borders
    float normalLowValue = 3.5f;
    float normalHighValue = 5.6f;
    if([[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]length]>0){
        normalLowValue= [[[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]substringToIndex:3]floatValue];
        normalHighValue = [[[[self.werteEinstellungen lastObject]valueForKey:@"bzzielbereich"]substringWithRange:NSMakeRange(4, 3)]floatValue];
    }
    if(normalHighValue<normalLowValue){
        float temp = normalLowValue;
        normalLowValue = normalHighValue;
        normalHighValue=temp;
    }
    // set the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw the linegraph
    [self drawLineGraphWithContext:context];
    CGContextStrokePath(context);
    
    // set the horicontal dash lines (help lines in the graph)
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
    
    // set the border lines (OK Values)
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetLineWidth(context,1.4);
    CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - normalLowValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - normalLowValue * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - normalHighValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - normalHighValue * kStepY);
    CGContextStrokePath(context);
    // set the border lines (NOT OK Values)
    CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
    CGContextSetLineDash(context, 0.0, NULL, 0);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - dangerousHighValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - dangerousHighValue * kStepY);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - dangerousLowValue * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - dangerousLowValue * kStepY);
    CGContextStrokePath(context);
    // set the border lines (Coordinate system)
    CGContextSetLineWidth(context,2.0);
    CGContextSetLineDash(context, 0, NULL, 0);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextAddLineToPoint(context, kDefaultGraphWidth+kOffsetX, kGraphBottom - kOffsetY - 0 * kStepY);
    CGContextMoveToPoint(context, kOffsetX + 0 * kStepX, kGraphTop);
    CGContextAddLineToPoint(context, kOffsetX + 0 * kStepX, kGraphBottom-kOffsetX);

    CGContextStrokePath(context);

//    [self drawBarGraphWithContext:context];
//    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
//    for (int i = 0; i < [self.blutzuckerValues count]; i++)
//    {
//        CGContextSelectFont(context, "Helvetica", 10, kCGEncodingMacRoman);
//        NSString *theText = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[[blutzuckerValues objectAtIndex:i]valueForKey:@"date"]]];
//        CGContextShowTextAtPoint(context, kOffsetX -13 + (i +1)* kStepX, kGraphBottom+3, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
//        CGContextSelectFont(context, "Helvetica", 12, kCGEncodingMacRoman);
//
//            NSString *theText2 = [NSString stringWithFormat:@"%@", [[blutzuckerValues objectAtIndex:i]valueForKey:@"value"]];
//            CGContextShowTextAtPoint(context, kOffsetX -8 + (i +1)* kStepX, kGraphBottom-70, [theText2 cStringUsingEncoding:NSUTF8StringEncoding], [theText2 length]);
//
//    }    
}

/**
 *  DEPRECATED
 *
 *  @param rect
 *  @param ctx
 */
- (void)drawBar:(CGRect)rect context:(CGContextRef)ctx
{
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}
/**
 *  perform the fetches: get blood sugar values from sugarmeDB
 */
-(void) performFetches{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Blutzucker" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *tempArray;
    tempArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    tempArray=[tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    self.blutzuckerValues=[[NSMutableArray alloc] initWithArray:tempArray];
    while (self.blutzuckerValues.count>10) {
        [self.blutzuckerValues removeObjectAtIndex:0];
    }
    
    // get settings
    NSFetchRequest *settingsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *settingsEntity = [NSEntityDescription
                                   entityForName:@"Werteeinstellungen" inManagedObjectContext:managedObjectContext];
    [settingsFetchRequest setEntity:settingsEntity];
    self.werteEinstellungen = [managedObjectContext executeFetchRequest:settingsFetchRequest error:&error];
    
}


@end
