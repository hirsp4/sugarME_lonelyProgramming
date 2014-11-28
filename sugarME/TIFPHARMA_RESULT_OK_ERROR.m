//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.0.0
//
// Created by Quasar Development at 27-11-2014
//
//---------------------------------------------------


#import <Foundation/Foundation.h>
    
#import "TIFPHARMA_RESULT_OK_ERROR.h"

@implementation TIFPHARMA_RESULT_OK_ERROR

-(id) initWithEnum:(NSString*)itemName value:(int) itemValue
{
    if(self = [super init])
    {
        self->name=itemName;
        self->value=itemValue;
    }
    return self;
}

-(NSString*) stringValue
{
    return name;
}
    
-(NSString*) description
{
    return name;
}

-(int) getValue
{
    return value;
}

-(BOOL) isEqualTo:(TIFPHARMA_RESULT_OK_ERROR *)item
{
    return [name isEqualToString:item->name];
}
   
-(void) serialize:(DDXMLNode*)parent
{
    [parent setStringValue:name];
}
     
+(TIFPHARMA_RESULT_OK_ERROR*) OK
{
    static TIFPHARMA_RESULT_OK_ERROR* obj=nil;
    if(!obj)
    {
        obj=[[TIFPHARMA_RESULT_OK_ERROR alloc] initWithEnum: @"OK" value: 0];
    }
    return obj;
} 
+(TIFPHARMA_RESULT_OK_ERROR*) ERROR
{
    static TIFPHARMA_RESULT_OK_ERROR* obj=nil;
    if(!obj)
    {
        obj=[[TIFPHARMA_RESULT_OK_ERROR alloc] initWithEnum: @"ERROR" value: 1];
    }
    return obj;
} 
    
+ (TIFPHARMA_RESULT_OK_ERROR *)createWithXml:(DDXMLNode *)node
{
    return [TIFPHARMA_RESULT_OK_ERROR createWithString:[node stringValue]];
}
    
+ (TIFPHARMA_RESULT_OK_ERROR *)createWithString:(NSString *)value
{
    if([value isEqualToString:@"ERROR"])
    {
        return [TIFPHARMA_RESULT_OK_ERROR ERROR];
    }
    return [TIFPHARMA_RESULT_OK_ERROR OK];   
}
    

@end