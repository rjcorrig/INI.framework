//
//  INI_framework_Tests.m
//  INI.framework Tests
//
//  Created by Robert Corrigan on 10/23/16.
//
//

#import <XCTest/XCTest.h>
#import "INI.h"

@interface INI_framework_Tests : XCTestCase

@end

@implementation INI_framework_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testINIEntry_EntryWithLine_KeyAndValue {
	INIEntry *entry = [INIEntry entryWithLine: @"  username  \t=  mirek  "];
	
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"mirek");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);

	XCTAssertEqual(entry.info.value.location, 16);
	XCTAssertEqual(entry.info.value.length, 5);

	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_EntryWithLine_KeyOnly {
	INIEntry *entry = [INIEntry entryWithLine: @"  username  \t="];
	
	XCTAssertEqualObjects(entry.key, @"username");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");

	XCTAssertEqual(entry.info.key.location, 2);
	XCTAssertEqual(entry.info.key.length, 8);
	
	XCTAssertEqual(entry.info.value.location, 14);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);

	XCTAssertEqual(entry.type, INIEntryTypeKeyValue);
}

- (void)testINIEntry_EntryWithLine_Section {
	INIEntry *entry = [INIEntry entryWithLine: @" [section] "];
	
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"section");

	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 2);
	XCTAssertEqual(entry.info.section.length, 7);

	XCTAssertEqual(entry.type, INIEntryTypeSection);
}

- (void)testINIEntry_EntryWithLine_Comment {
	INIEntry *entry = [INIEntry entryWithLine: @"# [section] "];
	
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeComment);
}

- (void)testINIEntry_EntryWithLine_Blank {
	INIEntry *entry = [INIEntry entryWithLine: @""];
	
	XCTAssertEqualObjects(entry.key, @"");
	XCTAssertEqualObjects(entry.value, @"");
	XCTAssertEqualObjects(entry.section, @"");
	
	XCTAssertEqual(entry.info.key.location, 0);
	XCTAssertEqual(entry.info.key.length, 0);
	
	XCTAssertEqual(entry.info.value.location, 0);
	XCTAssertEqual(entry.info.value.length, 0);
	
	XCTAssertEqual(entry.info.section.location, 0);
	XCTAssertEqual(entry.info.section.length, 0);
	
	XCTAssertEqual(entry.type, INIEntryTypeOther);
}

@end
