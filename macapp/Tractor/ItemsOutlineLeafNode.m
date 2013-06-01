#import "ItemsOutlineLeafNode.h"
#import "Item.h"

@implementation ItemsOutlineLeafNode

#pragma mark - Properties

- (NSString *)name
{
  NSString *name = nil;
  Item *item = [self item];

  if ([self isAway]) {
    name = [self awayName];
  } else if ([self isUntitled]) {
    name = @"Untitled";
  } else {
    name = [item title];
  }

  return name;
}

- (Project *)project
{
  return [[self item] project];
}
+ (NSSet *)keyPathsForValuesAffectingProject {
  return [NSSet setWithObject:@"item.project"];
}

- (NSDate *)start
{
  return [[self item] start];
}

- (NSTimeInterval)duration
{
  return [[self item] duration];
}

#pragma mark - ViewController Support

- (BOOL) isLeaf
{
  return YES;
}

- (NSString *)viewIdentifierForNameColumn
{
  return [self isUntitled] ? @"ItalicCell" : @"NormalCell";
}

- (void)changeProjectTo:(Project *)project
{
  [[self item] setProject:project];
}

#pragma mark - Tree Suppoert

- (BOOL)acceptsItem:(Item *)item
{
  return NO;
}

- (void)addItem:(Item *)item
{
  assert(![self item]);
  [self setItem:item];
}

#pragma mark - Helpers

- (NSString *)awayName
{
  Item *item = [self item];

  NSDateFormatter *timeFormatter = [[[NSDateFormatter alloc] init] autorelease];
  [timeFormatter setDateStyle:NSDateFormatterNoStyle];
  [timeFormatter setTimeStyle:NSDateFormatterShortStyle];

  NSString *startString = [timeFormatter stringFromDate:[item start]];
  NSString *endString = [timeFormatter stringFromDate:[item end]];

  return [NSString stringWithFormat:@"Away from %@ to %@", startString, endString];
}

- (BOOL)isUntitled
{
  Item *item = [self item];
  return [[item title] length] == 0;
}

- (BOOL)isAway
{
  return ![[self item] app];
}

@end
