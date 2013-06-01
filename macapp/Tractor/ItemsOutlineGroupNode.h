#import <Foundation/Foundation.h>
#import "Item.h"

@interface ItemsOutlineGroupNode : NSObject {
  NSMutableArray *_childNodes;
  NSMutableArray *_visibleChildNodes;
}

@property (nonatomic, readonly) BOOL isLeaf;
@property (nonatomic, retain) NSArray *visibleChildNodes;
@property (nonatomic, retain) NSString *filter;

- (void)addItem:(Item *)item;
- (void)addItems:(NSArray *)items;

- (BOOL)isFiltered;

@end
