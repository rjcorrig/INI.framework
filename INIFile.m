// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIFile.h"

@implementation INIFile

@synthesize entries;
@synthesize lineEnding = _lineEnding;
@synthesize path;
@synthesize encoding;

- (id) init {
  if (self = [super init]) {
    self.entries = [NSMutableArray array];
  }
  return self;
}

- (id) initWithUTF8ContentsOfFile: (NSString *) path_ error: (NSError **) error {
  self = [self initWithContentsOfFile:path_ encoding:NSUTF8StringEncoding error:error];
  return self;
}

- (id) initWithContentsOfFile: (NSString *) path_ encoding: (NSStringEncoding) encoding_ error: (NSError **) error {
  if (self = [self init]) {
    self.contents = [NSString stringWithContentsOfFile: path_ encoding: encoding_ error: error];
    self.encoding = encoding_;
    self.path = path_;
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
	INIEntry *updatingEntry = nil;
	NSString *currentSection = nil;
	NSInteger sectionIndex = -1;
	
	// Find the section and entry to modify
	for (INIEntry *entry in self.entries) {
		if ([entry.section isEqualToString:section]) {
			currentSection = entry.section;
			sectionIndex = [self.entries indexOfObject:entry];
		}
		if ([entry.key isEqualToString:key] && [currentSection isEqualToString:section]) {
			updatingEntry = entry;
			break;
		}
	}

	if (updatingEntry) {
		updatingEntry.value = value;
		return;
	}

	if (sectionIndex < 0) {
		INIEntry *newSection = [INIEntry entryWithLine:[NSString stringWithFormat:@"[%@]", section]];
		[self.entries addObject:newSection];
		sectionIndex = [self.entries count] - 1;
	}
	
	updatingEntry = [INIEntry entryWithLine:[NSString stringWithFormat:@"%@ = %@", key, value]];
	[self.entries insertObject:updatingEntry atIndex:sectionIndex+1];
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
