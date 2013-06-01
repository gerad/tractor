#import <Foundation/Foundation.h>
#import "Project.h"
#import "Item.h"

@protocol ItemsOutlineTreeNode <NSObject>

#pragma mark - Properties

- (NSString *)name;
- (Project *)project;
- (NSDate *)start;
- (NSTimeInterval)duration;

#pragma mark - ViewController Support

- (BOOL) isLeaf;
- (NSString *)viewIdentifierForNameColumn;

// can't be called `setProject` due to bindings issues (sigh)
- (void)changeProjectTo:(Project *)project;

#pragma mark - Tree Support

// whether the item is allowed in the child nodes of this node
- (BOOL)acceptsItem:(Item *)item;
- (void)addItem:(Item *)item;

@end
