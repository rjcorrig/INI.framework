// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIFile.h"

@implementation INIFile

@synthesize entries;
@synthesize lineEnding = _lineEnding;

- (id) init {
  if (self = [super init]) {
    self.entries = [NSMutableArray array];
  }
  return self;
}

- (id) initWithUTF8ContentsOfFile: (NSString *) path error: (NSError **) error {
  self = [self initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error];
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
    [contents_ appendFormat:@"%@%@", entry.line, (i < entries.count -1) ? _lineEnding : @""];
  }

  return contents_;
}

- (void) setContents: (NSString *) contents_ {
  self.entries = [NSMutableArray array];

  // Determine newline: LF, CR, or CRLF
  NSRange firstLineEnd = [contents_ rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
  if ([[contents_ substringWithRange:firstLineEnd] isEqualToString:@"\n"]) {
    _lineEnding = @"\n";
  } else {
    NSRange lineEndTest = NSMakeRange(firstLineEnd.location, 2);
    NSString *newLinee = [contents_ substringWithRange:lineEndTest];
    if ([newLinee isEqualToString:@"\r\n"]) {
      _lineEnding = @"\r\n";
    } else {
      _lineEnding = @"\r";
    }
  }
	
  for (NSString *line in [contents_ componentsSeparatedByString:_lineEnding]) {
    [self.entries addObject: [[INIEntry alloc] initWithLine: line]];
  }
}

- (NSString *) valueForKey: (NSString *) key {
  NSArray *values = [self valuesForKey: key];
    if ([values count] > 0) {
      return [values objectAtIndex:0];
    } else {
      return nil;
    }
}

- (NSMutableArray *) valuesForKey: (NSString *) key {
  NSMutableArray *values = [NSMutableArray array];
  for (INIEntry *entry in self.entries) {
    if ([entry.key isEqualToString:key]) {
      [values addObject:entry.value];
    }
  }
  return values;
}

- (NSString *) valueForKey: (NSString *) key inSection: (NSString *) section {
  NSArray *values = [self valuesForKey: key inSection: section];
  if ([values count] > 0) {
    return [values objectAtIndex:0];
  } else {
    return nil;
  }
}

- (NSMutableArray *) valuesForKey: (NSString *) key inSection: (NSString *) section {
  NSMutableArray *values = [NSMutableArray array];
  NSString *currentSection = nil;

  for (INIEntry *entry in self.entries) {
    if ([entry.section isEqualToString:section]) {
      currentSection = entry.section;
    }
    if ([entry.key isEqualToString:key] && [currentSection isEqualToString:section]) {
      [values addObject:entry.value];
    }
  }
  return values;
}

- (void) setValue: (NSString *) value forKey: (NSString *) key inSection: (NSString *) section {
}

- (NSIndexSet *) sectionIndexes {
  return [self.entries indexesOfObjectsPassingTest: ^(id entry, NSUInteger index, BOOL *stop) {
    return (BOOL)([(INIEntry *)entry type] == INIEntryTypeSection);
  }];
}

- (NSArray *) sections {
  return [self.entries objectsAtIndexes: [self sectionIndexes]];
}

@end
