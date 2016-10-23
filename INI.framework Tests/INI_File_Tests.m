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
}
@end
