// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIFile.h"

@implementation INIFile

@synthesize entries;
@synthesize newLine;

- (id) init {
  if (self = [super init]) {
    self.entries = [NSMutableArray array];
  }
  return self;
}

- (id) initWithUTF8ContentsOfFile: (NSString *) path error: (NSError **) error {
  if (self = [self init]) {
    self.contents = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: error];
  }
  return self;
}

- (id) initWithContentsOfFile: (NSString *) path encoding: (NSStringEncoding) encoding error: (NSError **) error {
  if (self = [self init]) {
    self.contents = [NSString stringWithContentsOfFile: path encoding: encoding error: error];
  }
  return self;
}

- (NSString*) contents {
  NSMutableString *contents_ = [[NSMutableString alloc] init];

  for (int i = 0; i < entries.count; i++) {
    INIEntry *entry = [entries objectAtIndex:i];
    [contents_ appendFormat:@"%@%@", entry.line, (i < entries.count -1) ? newLine : @""];
  }

  return contents_;
}

- (void) setContents: (NSString *) contents_ {
  self.entries = [NSMutableArray array];

  // Determine newline: LF, CR, or CRLF
  NSRange firstLineEnd = [contents_ rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
  if ([[contents_ substringWithRange:firstLineEnd] isEqualToString:@"\n"]) {
    newLine = @"\n";
  } else {
    NSRange lineEndTest = NSMakeRange(firstLineEnd.location, 2);
    NSString *newLinee = [contents_ substringWithRange:lineEndTest];
    if ([newLinee isEqualToString:@"\r\n"]) {
      newLine = @"\r\n";
    } else {
      newLine = @"\r";
    }
  }
	
  for (NSString *line in [contents_ componentsSeparatedByString:newLine]) {
    [self.entries addObject: [[INIEntry alloc] initWithLine: line]];
  }
}

- (NSString *) valueForKey: (NSString *) key {
  return nil;
}

- (NSMutableArray *) valuesForKey: (NSString *) key {
  return [NSMutableArray array];
}

- (NSString *) valueForKey: (NSString *) key inSection: (NSString *) section {
  return [[self valuesForKey: key inSection: section] objectAtIndex: 0];
}

- (NSMutableArray *) valuesForKey: (NSString *) key inSection: (NSString *) section {
  return [NSMutableArray array];
}

- (void) setValue: (NSString *) value forKey: (NSString *) key inSection: (NSString *) section {
}

- (NSIndexSet *) sectionIndexes {
  return [self.entries indexesOfObjectsPassingTest: ^(id entry, NSUInteger index, BOOL *stop) {
    return (BOOL)((INIEntry *)[entry type] == INIEntryTypeSection);
  }];
}

- (NSArray *) sections {
  return [self.entries objectsAtIndexes: [self sectionIndexes]];
}

@end
