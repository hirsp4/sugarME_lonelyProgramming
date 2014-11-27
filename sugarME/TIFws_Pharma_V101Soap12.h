//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 4.1.0.0
//
// Created by Quasar Development at 27-11-2014
//
//---------------------------------------------------



#import <Foundation/Foundation.h>

#import "TIFPHARMA.h"
#import "DDXML.h"

@class TIFRequestResultHandler;

@protocol TIFSoapServiceResponse < NSObject>
- (void) onSuccess: (id) value methodName:(NSString*)methodName;
- (void) onError: (NSError*) error;
@end


@interface TIFws_Pharma_V101Soap12 : NSObject
    
@property (retain, nonatomic) NSDictionary* Headers;
@property (retain, nonatomic) NSString* Url;
@property (nonatomic) BOOL ShouldAddAdornments;
@property BOOL EnableLogging;

- (id) init;
- (id) initWithUrl: (NSString*) url;

-(NSMutableURLRequest*) createDownloadAllRequest:(NSString*) lang __request:(TIFRequestResultHandler*) __request;
-(TIFPHARMA*) DownloadAll:(NSString*) lang __error:(NSError**) __error;
-(TIFRequestResultHandler*) DownloadAllAsync:(NSString*) lang __target:(id) __target __handler:(SEL) __handler;
-(TIFRequestResultHandler*) DownloadAllAsync:(NSString*) lang __target:(id<TIFSoapServiceResponse>) __target;
-(NSMutableURLRequest*) createDownloadByDateRequest:(NSDate*) mutationDate lang:(NSString*) lang __request:(TIFRequestResultHandler*) __request;
-(TIFPHARMA*) DownloadByDate:(NSDate*) mutationDate lang:(NSString*) lang __error:(NSError**) __error;
-(TIFRequestResultHandler*) DownloadByDateAsync:(NSDate*) mutationDate lang:(NSString*) lang __target:(id) __target __handler:(SEL) __handler;
-(TIFRequestResultHandler*) DownloadByDateAsync:(NSDate*) mutationDate lang:(NSString*) lang __target:(id<TIFSoapServiceResponse>) __target;
-(NSMutableURLRequest*) createGetByGTINRequest:(NSString*) GTIN lang:(NSString*) lang __request:(TIFRequestResultHandler*) __request;
-(TIFPHARMA*) GetByGTIN:(NSString*) GTIN lang:(NSString*) lang __error:(NSError**) __error;
-(TIFRequestResultHandler*) GetByGTINAsync:(NSString*) GTIN lang:(NSString*) lang __target:(id) __target __handler:(SEL) __handler;
-(TIFRequestResultHandler*) GetByGTINAsync:(NSString*) GTIN lang:(NSString*) lang __target:(id<TIFSoapServiceResponse>) __target;
-(NSString*) GetByPharmacode:(NSString*) pharmacode lang:(NSString*) lang __error:(NSError**) __error;
-(TIFRequestResultHandler*) GetByPharmacodeAsync:(NSString*) pharmacode lang:(NSString*) lang __target:(id) __target __handler:(SEL) __handler;
-(TIFRequestResultHandler*) GetByPharmacodeAsync:(NSString*) pharmacode lang:(NSString*) lang __target:(id<TIFSoapServiceResponse>) __target;
-(NSString*) GetByDescr:(NSString*) descr lang:(NSString*) lang __error:(NSError**) __error;
-(TIFRequestResultHandler*) GetByDescrAsync:(NSString*) descr lang:(NSString*) lang __target:(id) __target __handler:(SEL) __handler;
-(TIFRequestResultHandler*) GetByDescrAsync:(NSString*) descr lang:(NSString*) lang __target:(id<TIFSoapServiceResponse>) __target;
-(TIFRequestResultHandler*) CreateRequestResultHandler;   
-(NSMutableURLRequest*) createRequest :(NSString*) soapAction __request:(TIFRequestResultHandler*) __request; 
-(void) sendImplementation:(NSMutableURLRequest*) request requestMgr:(TIFRequestResultHandler*) requestMgr; 
-(void) sendImplementation:(NSMutableURLRequest*) request requestMgr:(TIFRequestResultHandler*) requestMgr callback:(void (^)(TIFRequestResultHandler *)) callback;

@end
