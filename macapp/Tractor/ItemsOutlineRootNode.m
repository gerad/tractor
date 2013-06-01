#import "ItemsOutlineRootNode.h"
#import "AppGroupTreeNode.h"

@implementation ItemsOutlineRootNode

- (id<ItemsOutlineTreeNode>)newChildNode;
{
  return [[AppGroupTreeNode alloc] init];
}


- (void)sort
{
  NSSortDescriptor *descendingDuration = [NSSortDescriptor sortDescriptorWithKey:@"duration" ascending:NO];
  return [_childNodes sortUsingDescriptors:@[descendingDuration]];
}

/*
- (void)dealloc
{
  [_appGroupNodeDictionary release];
  [super dealloc];
}

- (NSMutableDictionary *)appGroupNodeDictionary
{
  if (!_appGroupNodeDictionary) {
    _appGroupNodeDictionary = [[NSMutableDictionary alloc] init];
  }

  return _appGroupNodeDictionary;
}

- (AppGroupTreeNode *)appGroupTreeNodeForItem:(Item *)item
{
  NSString *app = [item app];
  id key = app ? app : [NSNull null];

  AppGroupTreeNode *node = _appGroupNodeDictionary[key];

  if (!node) {
    node = [[[AppGroupTreeNode alloc] init] autorelease];
    _appGroupNodeDictionary[key] = node;
  }

  return node;
}
*/

@end
