#import "ItemsOutlineGroupNode.h"
#import "ItemsOutlineTreeNode.h"

@interface AppGroupTreeNode : ItemsOutlineGroupNode<ItemsOutlineTreeNode> {
  BOOL _projectNeedsUpdate;
  BOOL _durationNeedsUpdate;
  BOOL _isChangingProject;
}

@property (nonatomic, readonly) NSImage *icon;
@property (nonatomic, retain) Project *project;

@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, assign) NSTimeInterval duration;

@end
