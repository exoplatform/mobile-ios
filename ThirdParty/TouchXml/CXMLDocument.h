//
//  CXMLDocument.h
//  TouchXML
//
//  Created by Jonathan Wight on 03/07/08.
//  Copyright (c) 2008 Jonathan Wight

#import "CXMLNode.h"

enum 
{
	CXMLDocumentTidyHTML = 1 << 9
};

@class CXMLElement;

@interface CXMLDocument : CXMLNode {
	NSMutableSet* nodePool;
}

- (instancetype)initWithXMLString:(NSString*)inString options:(NSUInteger)inOptions error:(NSError**)outError;
- (instancetype)initWithContentsOfURL:(NSURL*)inURL options:(NSUInteger)inOptions error:(NSError**)outError;
- (instancetype)initWithData:(NSData*)inData options:(NSUInteger)inOptions error:(NSError**)outError;

//- (NSString *)characterEncoding;
//- (NSString *)version;
//- (BOOL)isStandalone;
//- (CXMLDocumentContentKind)documentContentKind;
//- (NSString *)MIMEType;
//- (CXMLDTD *)DTD;

@property (nonatomic, readonly, strong) CXMLElement *rootElement;

//- (NSData *)XMLData;
//- (NSData *)XMLDataWithOptions:(NSUInteger)options;

//- (id)objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
//- (id)objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;

//- (id)XMLStringWithOptions:(NSUInteger)options;

@end
