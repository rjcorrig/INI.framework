//
//  INI_File_Tests.m
//  INI
//
//  Created by Robert Corrigan on 10/23/16.
//
//

#import <XCTest/XCTest.h>
#import "INI.h"

@interface INI_File_Tests : XCTestCase

@end

@implementation INI_File_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testINIFile_initWithUTF8ContentsOfFile_CRLF {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_crlf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 10);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.newLine, @"\r\n");
}

- (void)testINIFile_initWithUTF8ContentsOfFile_CR {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_cr" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 10);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.newLine, @"\r");
}

- (void)testINIFile_initWithUTF8ContentsOfFile_LF {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 11);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.newLine, @"\n");
}

- (void)testINIFile_sections {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config sections] count], 2);
}

- (void)testINIFile_valueForKey_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqualObjects([config valueForKey:@"name"], @"Mirek Rusin");
}

- (void)testINIFile_valuesForKey_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"name"];
	XCTAssertEqual([values count], 2);
	XCTAssertEqualObjects([values objectAtIndex:0], @"Mirek Rusin");
	XCTAssertEqualObjects([values objectAtIndex:1], @"MirekRusin");
}

- (void)testINIFile_valueForKey_InSection_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqualObjects([config valueForKey:@"name" inSection:@"github"], @"MirekRusin");
}

- (void)testINIFile_valuesForKey_InSection_Found {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"name" inSection:@"github"];
	XCTAssertEqual([values count], 1);
	XCTAssertEqualObjects([values objectAtIndex:0], @"MirekRusin");
}

- (void)testINIFile_valueForKey_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertNil([config valueForKey:@"nam"]);
}

- (void)testINIFile_valuesForKey_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"nam"];
	XCTAssertEqual([values count], 0);
}

- (void)testINIFile_valueForKey_InSection_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertNil([config valueForKey:@"name" inSection:@"use"]);
}

- (void)testINIFile_valuesForKey_InSection_NotFound {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test_lf" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valuesForKey:@"name" inSection:@"use"];
	XCTAssertEqual([values count], 0);
}

@end
