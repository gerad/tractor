#import "ItemsOutlineGroupNode.h"
#import "ItemsOutlineTreeNode.h"

@implementation ItemsOutlineGroupNode

#pragma mark - Lifecycle

- (id)init
{
  if (self = [super init]) {
    _childNodes = [[NSMutableArray alloc] init];
    _visibleChildNodes = [[NSMutableArray alloc] init];
  }

  return self;
}

- (void)dealloc
{
  [_childNodes release];
  [_visibleChildNodes release];
  [self setFilter:nil];
  [super dealloc];
}

#pragma mark - Properties

- (NSArray *)visibleChildNodes
{
  return _childNodes;
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


@end
