#import "AppGroupTreeNode.h"
#import "ItemsOutlineLeafNode.h"

@implementation AppGroupTreeNode

#pragma mark - Lifecycle

- (void)dealloc
{
  [self setProject:nil];

  for (ItemsOutlineLeafNode *child in _childNodes) {
    [[child item] removeObserver:self forKeyPath:@"project"];
  }

  [super dealloc];
}

#pragma mark - Properties

- (NSString *)name
{
  NSString *appName = [self appName];
  return appName ? appName : @"Away";
}

- (NSImage *)icon
{
  NSImage *icon = nil;
  NSString *app = [self appName];

  if (app) {
    NSString *path = [NSString stringWithFormat:@"/Applications/%@.app", app];
    icon = [[NSWorkspace sharedWorkspace] iconForFile:path];
  }

  if (!icon) {
    icon = [NSImage imageNamed:@"NSDefaultApplicationIcon"];
  }

  return icon;
}

- (Project *)project
{
  if (_projectNeedsUpdate) { [self updateProject]; }
  return _project;
}

- (NSTimeInterval)duration
{
  if (_durationNeedsUpdate) { [self updateDuration]; }
  return _duration;
}

#pragma mark - ViewController Support

- (NSString *)viewIdentifierForNameColumn
{
  return [self appName] ? @"ApplicationCell" : @"ItalicCell";
}

- (void)changeProjectTo:(Project *)project
{
  _isChangingProject = YES;
  for (ItemsOutlineLeafNode *child in _childNodes) {
    [child changeProjectTo:project];
  }
  _isChangingProject = NO;
  [self updateProject];
}

#pragma mark - Tree Support

- (BOOL)acceptsItem:(Item *)item
{
  return ([item app] == nil && [self appName] == nil) || [[item app] isEqualToString:[self appName]];
}

- (void)addItem:(Item *)item
{
  [super addItem:item];
  [self observeProjectChangeForItem:item];
  _projectNeedsUpdate = YES;
  _durationNeedsUpdate = YES;
}

- (id<ItemsOutlineTreeNode>)newChildNode
{
  return [[ItemsOutlineLeafNode alloc] init];
}

#pragma mark - Helpers

- (NSString *)appName
{
  Item *firstItem = [self firstItem];
  return [firstItem app];
}

- (Item *)firstItem
{
  return [_childNodes[0] item];
}

- (void)updateProject
{
  Project *project = [[self firstItem] project];

  for (ItemsOutlineLeafNode *child in [self visibleChildNodes]) {
    if ([child project] != project) {
      project = nil;
      break;
    }
  }

  _projectNeedsUpdate = NO;
  [self setProject:project];
}

- (void)updateDuration
{
  NSTimeInterval duration = 0;

  for (ItemsOutlineLeafNode *child in [self visibleChildNodes]) {
    duration += [child duration];
  }

  _durationNeedsUpdate = NO;
  [self setDuration:duration];
}


- (void)observeProjectChangeForItem:(Item *)item
{
  [item addObserver:self
         forKeyPath:@"project"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
  if ([keyPath isEqual:@"project"]) {
    if (!_isChangingProject) {
      [self updateProject];
    }
  }
}


@end
