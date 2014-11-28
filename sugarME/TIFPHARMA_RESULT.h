//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.0.0
//
// Created by Quasar Development at 27-11-2014
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

@class TIFPHARMA_RESULT_OK_ERROR;
#import "TIFRequestResultHandler.h"
#import "DDXML.h"



@interface TIFPHARMA_RESULT : NSObject 


@property (retain,nonatomic,getter=getOK_ERROR) TIFPHARMA_RESULT_OK_ERROR* OK_ERROR;

@property (retain,nonatomic,getter=getNBR_RECORD) NSNumber* NBR_RECORD;

@property (retain,nonatomic,getter=getERROR_CODE) NSString* ERROR_CODE;

@property (retain,nonatomic,getter=getMESSAGE) NSString* MESSAGE;
-(id)init;
-(id)initWithXml: (DDXMLElement*)__node __request:(TIFRequestResultHandler*) __request;
+(TIFPHARMA_RESULT*) createWithXml:(DDXMLElement*)__node __request:(TIFRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(TIFRequestResultHandler*) __request;
@end