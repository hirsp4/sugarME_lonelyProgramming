//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.0.0
//
// Created by Quasar Development at 27-11-2014
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

@class TIFHelper;
@class TIFPHARMA_ITEM_STATUS;
@class TIFPHARMA_ITEM_COMP;
#import "TIFRequestResultHandler.h"
#import "DDXML.h"



@interface TIFPHARMA_ITEM : NSObject 


@property (retain,nonatomic,getter=getGTIN) NSString* GTIN;

@property (retain,nonatomic,getter=getPHAR) NSNumber* PHAR;

@property (retain,nonatomic,getter=getSTATUS) TIFPHARMA_ITEM_STATUS* STATUS;

@property (retain,nonatomic,getter=getSTDATE) NSDate* STDATE;

@property (retain,nonatomic,getter=getLANG) NSString* LANG;

@property (retain,nonatomic,getter=getDSCR) NSString* DSCR;

@property (retain,nonatomic,getter=getADDSCR) NSString* ADDSCR;

@property (retain,nonatomic,getter=getATC) NSString* ATC;

@property (retain,nonatomic,getter=getCOMP) TIFPHARMA_ITEM_COMP* COMP;

@property (retain,nonatomic,getter=getDT) NSDate* DT;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(TIFRequestResultHandler*) __request;
+(TIFPHARMA_ITEM*) createWithXml:(DDXMLElement*)__node __request:(TIFRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(TIFRequestResultHandler*) __request;
@end