#import "ItemsOutlineGroupNode.h"
#import "ItemsOutlineTreeNode.h"

@implementation ItemsOutlineGroupNode

#pragma mark - Lifecycle

- (id)init
{
  if (self = [super init]) {
    _childNodes = [[NSMutableArray alloc] init];
  }

  return self;
}

- (void)dealloc
{
  [_childNodes release];
  [_visibleChildNodes release];
  [_filter release];
  [super dealloc];
}

#pragma mark - Properties

- (NSArray *)visibleChildNodes
{
  if (!_visibleChildNodes) { [self updateVisibleChildNodes]; }
  return _visibleChildNodes;
}

#pragma mark - Item Methods

- (void)addItem:(Item *)item
{
  id<ItemsOutlineTreeNode> node = [self childNodeForItem:item];

  if (!node) {
    node = [self newChildNode];
    [_childNodes addObject:node];
    [node release];
  }

  [node addItem:item];
}

- (void)addItems:(NSArray *)items
{
  for (Item *item in items) {
    [self addItem:item];
  }
}

#pragma mark - Filter Methods

- (void)setFilter:(NSString *)filter
{
  [[self filter] autorelease];
  _filter = [filter retain];
  [self updateVisibleChildNodes];
}

- (BOOL)isFiltered
{
  return [[self visibleChildNodes] count] == 0;
}

#pragma mark - Helpers

- (id)childNodeForItem:(Item *)item;
{
  id<ItemsOutlineTreeNode> ret = nil;

  for (id<ItemsOutlineTreeNode> node in _childNodes) {
    if ([node acceptsItem:item]) {
      ret = node;
      break;
    }
  }

  return ret;
}

- (id<ItemsOutlineTreeNode>)newChildNode;
{
  return nil; // sublcasses should implement
}

- (void)updateVisibleChildNodes
{
  NSMutableArray *visibleChildNodes = [NSMutableArray array];

  for (id<ItemsOutlineTreeNode> node in _childNodes) {
    [node setFilter:[self filter]];
    if (![node isFiltered]) {
      [visibleChildNodes addObject:node];
    }
  }

  [self setVisibleChildNodes:visibleChildNodes];
}

@end
