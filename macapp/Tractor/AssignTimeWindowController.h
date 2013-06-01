#import <Cocoa/Cocoa.h>
#import "ManagedObjectContext.h"
#import "AddProjectSheetController.h"
#import "ItemsOutlineRootNode.h"

@interface AssignTimeWindowController : NSWindowController<NSDatePickerCellDelegate, NSOutlineViewDelegate, NSWindowDelegate, AddProjectSheetControllerDelegate> {
  IBOutlet NSDatePickerCell *datePicker;

  IBOutlet NSMenu *projectsMenu;
  IBOutlet NSMenuItem *titleMenuItem;
  IBOutlet NSMenuItem *newProjectMenuItem;
  IBOutlet NSMenuItem *separatorMenuItem;
  IBOutlet NSMenuItem *noProjectMenuItem;

  IBOutlet NSOutlineView *itemsOutlineView;

  AddProjectSheetController *addProjectSheetController;
}

@property (nonatomic, retain) NSDate *currentDate;
@property (nonatomic, retain) ManagedObjectContext *context;
@property (nonatomic, retain) ItemsOutlineRootNode *itemsOutlineRootNode;
@property (nonatomic, retain) NSArray *displayItems;

- (IBAction)showNewProjectSheet:(id)sender;
- (IBAction)searchItems:(id)sender;

@end
