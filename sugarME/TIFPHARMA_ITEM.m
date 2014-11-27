//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.0.0
//
// Created by Quasar Development at 27-11-2014
//
//---------------------------------------------------


#import "TIFHelper.h"
#import "TIFPHARMA_ITEM_STATUS.h"
#import "TIFPHARMA_ITEM_COMP.h"
#import "TIFPHARMA_ITEM.h"


@implementation TIFPHARMA_ITEM
@synthesize GTIN;
@synthesize PHAR;
@synthesize STATUS;
@synthesize STDATE;
@synthesize LANG;
@synthesize DSCR;
@synthesize ADDSCR;
@synthesize ATC;
@synthesize COMP;
@synthesize DT;

+ (TIFPHARMA_ITEM *)createWithXml:(DDXMLElement *)__node __request:(TIFRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    return [[self alloc] initWithXml: __node __request:__request];
}

-(id)init {
    if ((self=[super init])) {
        self.STATUS =TIFPHARMA_ITEM_STATUS.A;
    }
    return self;
}

- (id) initWithXml: (DDXMLElement*) __node __request:(TIFRequestResultHandler*) __request{
    if(self = [self init])
    {
        if([TIFHelper hasValue:__node name:@"GTIN" index:0])
        {
            self.GTIN = [[TIFHelper getNode:__node name:@"GTIN" index:0] stringValue];
        }
        if([TIFHelper hasValue:__node name:@"PHAR" index:0])
        {
            self.PHAR = [TIFHelper getNumber:[[TIFHelper getNode:__node name:@"PHAR" index:0] stringValue]];
        }
        if([TIFHelper hasValue:__node name:@"STATUS" index:0])
        {
            self.STATUS = (TIFPHARMA_ITEM_STATUS*)[TIFPHARMA_ITEM_STATUS createWithXml:[TIFHelper getNode:__node name:@"STATUS" index:0]];
        }
        if([TIFHelper hasValue:__node name:@"STDATE" index:0])
        {
            self.STDATE = [TIFHelper getDate:[[TIFHelper getNode:__node name:@"STDATE" index:0] stringValue]];
        }
        if([TIFHelper hasValue:__node name:@"LANG" index:0])
        {
            self.LANG = [[TIFHelper getNode:__node name:@"LANG" index:0] stringValue];
        }
        if([TIFHelper hasValue:__node name:@"DSCR" index:0])
        {
            self.DSCR = [[TIFHelper getNode:__node name:@"DSCR" index:0] stringValue];
        }
        if([TIFHelper hasValue:__node name:@"ADDSCR" index:0])
        {
            self.ADDSCR = [[TIFHelper getNode:__node name:@"ADDSCR" index:0] stringValue];
        }
        if([TIFHelper hasValue:__node name:@"ATC" index:0])
        {
            self.ATC = [[TIFHelper getNode:__node name:@"ATC" index:0] stringValue];
        }
        if([TIFHelper hasValue:__node name:@"COMP" index:0])
        {
            self.COMP = (TIFPHARMA_ITEM_COMP*)[__request createObject:[TIFHelper getNode:__node name:@"COMP" index:0] type:[TIFPHARMA_ITEM_COMP class]];
        }
        if([TIFHelper hasAttribute:__node name:@"DT"])
        {
            self.DT = [TIFHelper getDate:[[TIFHelper getAttribute:__node name:@"DT"] stringValue]];
        }
    }
    return self;
}

-(void) serialize:(DDXMLElement*)__parent __request:(TIFRequestResultHandler*) __request
{

             
    DDXMLElement* __GTINItemElement=[__request writeElement:GTIN type:[NSString class] name:@"GTIN" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__GTINItemElement!=nil)
    {
        [__GTINItemElement setStringValue:self.GTIN];
    }
             
    DDXMLElement* __PHARItemElement=[__request writeElement:PHAR type:[NSNumber class] name:@"PHAR" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__PHARItemElement!=nil)
    {
        [__PHARItemElement setStringValue:[self.PHAR stringValue]];
    }
             
    DDXMLElement* __STATUSItemElement=[__request writeElement:STATUS type:[TIFPHARMA_ITEM_STATUS class] name:@"STATUS" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:NO];
    if(__STATUSItemElement!=nil)
    {
        [self.STATUS serialize:__STATUSItemElement];
    }
             
    DDXMLElement* __STDATEItemElement=[__request writeElement:STDATE type:[NSDate class] name:@"STDATE" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:NO];
    if(__STDATEItemElement!=nil)
    {
        [__STDATEItemElement setStringValue:[TIFHelper getStringFromDate:self.STDATE]];
    }
             
    DDXMLElement* __LANGItemElement=[__request writeElement:LANG type:[NSString class] name:@"LANG" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__LANGItemElement!=nil)
    {
        [__LANGItemElement setStringValue:self.LANG];
    }
             
    DDXMLElement* __DSCRItemElement=[__request writeElement:DSCR type:[NSString class] name:@"DSCR" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__DSCRItemElement!=nil)
    {
        [__DSCRItemElement setStringValue:self.DSCR];
    }
             
    DDXMLElement* __ADDSCRItemElement=[__request writeElement:ADDSCR type:[NSString class] name:@"ADDSCR" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__ADDSCRItemElement!=nil)
    {
        [__ADDSCRItemElement setStringValue:self.ADDSCR];
    }
             
    DDXMLElement* __ATCItemElement=[__request writeElement:ATC type:[NSString class] name:@"ATC" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__ATCItemElement!=nil)
    {
        [__ATCItemElement setStringValue:self.ATC];
    }
             
    DDXMLElement* __COMPItemElement=[__request writeElement:COMP type:[TIFPHARMA_ITEM_COMP class] name:@"COMP" URI:@"http://swissindex.e-mediat.net/SwissindexPharma_out_V101" parent:__parent skipNullProperty:YES];
    if(__COMPItemElement!=nil)
    {
        [self.COMP serialize:__COMPItemElement __request: __request];
    }
             
    DDXMLNode* __DTItemElement=[__request addAttribute:@"DT" URI:@"" stringValue:@"" element:__parent];
    [__DTItemElement setStringValue:[TIFHelper getStringFromDate:self.DT]];


}
@end
