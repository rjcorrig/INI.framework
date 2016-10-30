// © 2010 Mirek Rusin
// Released under the Apache License, Version 2.0
// http://www.apache.org/licenses/LICENSE-2.0

#import "INIEntry.h"

@implementation INIEntry

@synthesize type;
@synthesize info;
@synthesize line;

- (id) init {
  if (self = [super init]) {
    info.section = NSMakeRange(0, 0);
    info.key = NSMakeRange(0, 0);
    info.value = NSMakeRange(0, 0);
    type = INIEntryTypeOther;
  }
  return self;
}

- (id) initWithLine: (NSString *) line_ {
  if (self = [self init]) {
    self.line = [line_ mutableCopy];
  }
  return self;
}

+ (INIEntry *) entryWithLine: (NSString *) line {
  return [[INIEntry alloc] initWithLine: line];
}

- (void) setLine: (NSString *) line_ {
  line = line_;
  [self parse];
}

- (void) parse {
  info.section = NSMakeRange(0, 0);
  info.key = NSMakeRange(0, 0);
  info.value = NSMakeRange(0, 0);
  type = INIEntryTypeOther;
  
  if ([[line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
    NSUInteger n = line.length;
    NSUInteger j;
    char state = ' ';
    for (NSUInteger i = 0; i < n; i++) {
      switch (state) {
          
        // Whitespace at the beginning of line or initial state
        case ' ': 
          switch ([line characterAtIndex: i]) {
              
            case ' ':
            case '\t':
              break;
              
            case '[':
              state = '[';
              info.section.location = i + 1;
              type = INIEntryTypeSection;
              break;
            
            case '#':
            case ';':
              state = '.';
              type = INIEntryTypeComment;
              break;
              
            default:
              state = 'k';
              info.key.location = i;
              type = INIEntryTypeKeyValue;
              break;
          }
          break;
          
        // Section
        case '[':
          switch ([line characterAtIndex: i]) {
            case ']':
              info.section.length = i - info.section.location;
              state = '.';
              break;
          }
          break;
          
        // Key
        case 'k':
          switch ([line characterAtIndex: i]) {
            case ' ':
              // let's look ahead to see if it's the end of the key or just a key with a space in the middle
              for (j = i; j < n && ([line characterAtIndex: j] == ' ' || [line characterAtIndex: j] == '\t'); j++) {}
              if (j == n) {
                // malformed entry, we were looking for = sign after the key and reached end of the line
                state = '.';
		info.key.location = 0;
                type = INIEntryTypeOther;
              } else {
                if ([line characterAtIndex: j] == '=') {
                  // the key finished at i - 1 (before this whitespace), there were just whitespaces before = sign
                  info.key.length = i - info.key.location;
                  // ...let's skip all those whitespaces, equal sign and all whitespaces after the sign
                  // and jump straight to 'v'alue state
                  for (j = j + 1; j < n && ([line characterAtIndex: j] == ' ' || [line characterAtIndex: j] == '\t'); j++) {}

                  if (j == n) {
                    // value is blank
                    info.value.length = 0;
                    state = '.';
                  } else {
                    state = 'v';
                  }

                  i = j - 1;
                  info.value.location = j;

		} else {
                  // we're still in the key with the whitespaces in the middle
                  // let's skip them and continue inside 'k'ey state
                  i = j - 1;
                }
              }
              break;
          }
          break;
          
        // Value
        case 'v':
          if (i == n - 1) {
            // it's the last char
            info.value.length = (i + 1) - info.value.location;
            state = '.';
          } else {
            // it's not the last char
            switch ([line characterAtIndex: i]) {
              case ' ':
                // are those white spaces to ignore just before the end of line?
                for (j = i; j < n && ([line characterAtIndex: j] == ' ' || [line characterAtIndex: j] == '\t'); j++) {}
                if (j == n) {
                  // ...yep, we've got the value - capture it without the whitespaces at the end and go to '.'final state
                  info.value.length = i - info.value.location;
                  state = '.';
                }
                break;
            }
          }
          break;
        
        // Fin
        case '.':
          i = n;
          break;
        
      }
    }
    
    if (state != '.') {
      type = INIEntryTypeOther;
    }
  }
}

- (NSString *) key {
  return [line substringWithRange: info.key];
}

- (void) setKey: (NSString *) key_ {
	if ([[key_ stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]) {
		line = [line stringByReplacingOccurrencesOfString:self.key withString:key_];
		[self parse];
	}
}

- (NSString *) value {
  return [line substringWithRange: info.value];
}

- (void) setValue: (NSString *) value_ {
	line = [line stringByReplacingOccurrencesOfString:self.value withString:value_];
	[self parse];
}

- (NSString *) section {
  return [line substringWithRange: info.section];
}

@end
