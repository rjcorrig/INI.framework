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

- (void)testINIFile_initWithUTF8ContentsOfFile {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config entries] count], 10);
	
	NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
	XCTAssertEqualObjects(contents, config.contents);
	XCTAssertEqual(contents.length, config.contents.length);
	
	XCTAssertEqualObjects(config.newLine, @"\r\n");
}

- (void)testINIFile_sections {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqual([[config sections] count], 2);
}

- (void)testINIFile_valueForKey {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqualObjects([config valueForKey:@"name"], @"Mirek Rusin");
}

- (void)testINIFile_valuesForKey {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valueForKey:@"name"];
	XCTAssertEqualObjects([values objectAtIndex:0], @"Mirek Rusin");
}

- (void)testINIFile_valueForKey_InSection {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	XCTAssertEqualObjects([config valueForKey:@"name" inSection:@"user"], @"Mirek Rusin");
}

- (void)testINIFile_valuesForKey_InSection {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	NSString *path = [bundle pathForResource:@"test" ofType:@"ini"];
	NSError *err;
	
	INIFile *config = [[INIFile alloc] initWithUTF8ContentsOfFile:path error:&err];
	
	XCTAssertNil(err);
	
	NSMutableArray *values = [config valueForKey:@"name" inSection:@"user"];
	XCTAssertEqualObjects([values objectAtIndex:0], @"Mirek Rusin");
}

@end
