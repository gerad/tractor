#import <Foundation/Foundation.h>
#import "ItemsOutlineTreeNode.h"

@interface ItemsOutlineLeafNode : NSObject<ItemsOutlineTreeNode>

@property (nonatomic, retain) Item *item;
@property (nonatomic, retain) NSString *filter;

@end
