#import "AssignTimeWindowController.h"
#import "ItemsOutlineTreeNode.h"
#import "ItemsOutlineLeafNode.h"
#import "AppGroupTreeNode.h"

@implementation AssignTimeWindowController

@synthesize context;

#pragma mark - Lifecycle

- (id)initWithWindow:(NSWindow *)window
{
  self = [super initWithWindow:window];
  if (self) {
    // initializers
  }

  return self;
}

- (void)dealloc
{
  [self setItemsOutlineRootNode:nil];
  [self setCurrentDate:nil];
  [addProjectSheetController release];
  [super dealloc];
}

- (void)awakeFromNib
{
  [self italicizeNoProjectMenuItemTitle];
}

- (void)italicizeNoProjectMenuItemTitle
{
  NSString *unassignTitle = [noProjectMenuItem title];
  NSFont *italicFont = [NSFont fontWithName:@"Helvetica Oblique" size:13.0];
  NSAttributedString *italicUnassignTitle = [[[NSMutableAttributedString alloc] initWithString: unassignTitle attributes:@{NSFontAttributeName: italicFont }] autorelease];
  [noProjectMenuItem setAttributedTitle:italicUnassignTitle];
}

#pragma mark - NSSearchField

- (IBAction)searchItems:(id)sender
{
  NSSearchField *searchField = sender;
  [[self itemsOutlineRootNode] setFilter:[searchField stringValue]];
}

#pragma mark - NSPopupButton

- (IBAction)showNewProjectSheet:(id)sender
{
  [[self addProjectSheetController] showSheetForWindow:[self window]];
}

- (IBAction)assignItemsToProject:(NSMenuItem *)menuItem
{
  Project *project = [[[self context] projects] findOrAddProjectWithName:[menuItem title]];
  NSIndexSet *selectedRowIndexes = [itemsOutlineView selectedRowIndexes];

  [selectedRowIndexes enumerateIndexesUsingBlock:^(NSUInteger row, BOOL *stop) {
    id item = [itemsOutlineView itemAtRow:row];
    id<ItemsOutlineTreeNode> controller = [item representedObject];
    [controller changeProjectTo:project];
  }];
}

- (void)populateProjectPicker
{
  [titleMenuItem retain];
  [noProjectMenuItem retain];
  [separatorMenuItem retain];
  [newProjectMenuItem retain];

  [projectsMenu removeAllItems];

  [projectsMenu addItem:titleMenuItem];
  [projectsMenu addItem:noProjectMenuItem];

  NSArray *projects = [[[self context] projects] all];
  if ([projects count] > 0) {
    for (Project *project in projects) {
      [projectsMenu addItemWithTitle:[project name]
                              action:@selector(assignItemsToProject:)
                       keyEquivalent:@""];
    }
  } else {
    [separatorMenuItem setHidden:YES];
  }
  [projectsMenu addItem:separatorMenuItem];
  [projectsMenu addItem:newProjectMenuItem];

  [titleMenuItem release];
  [noProjectMenuItem release];
  [separatorMenuItem release];
  [newProjectMenuItem release];
}

#pragma mark - NSWindowDelegate

- (void)windowDidBecomeMain:(NSNotification *)notification
{
  [self populateProjectPicker];

  if (![self currentDate]) {
    [self setCurrentDate:[NSDate date]];
    [datePicker setDateValue:[self currentDate]];
  } else {
    [self updateItemsTreeContent];
  }
}

#pragma mark - NSDatePickerCellDelegate

-      (void)datePickerCell:(NSDatePickerCell *)aDatePickerCell
  validateProposedDateValue:(NSDate **)proposedDateValue
               timeInterval:(NSTimeInterval *)proposedTimeInterval
{
  if (*proposedDateValue) {
    [self setCurrentDate:*proposedDateValue];
    [self updateItemsTreeContent];
  } else {
    *proposedDateValue = [self currentDate];
  }
}

#pragma mark - NSOutlineViewDelegate

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
  NSString *identifier = [tableColumn identifier];

  if ([identifier isEqualToString:@"Name"]) {
    id <ItemsOutlineTreeNode> rowViewController = [item representedObject];
    identifier = [rowViewController viewIdentifierForNameColumn];
  }

  return [outlineView makeViewWithIdentifier:identifier owner:self];
}

#pragma mark - itemsTreeController

- (void)updateItemsTreeDisplayedContent
{
//  NSString *query = [searchField stringValue];
//  NSArray *itemsMatchingQuery = [self items];
//  [self setDisplayItems:itemsMatchingQuery];
}

- (void)updateItemsTreeContent
{
  NSArray *items = [[context items] itemsForDay:[self currentDate]];

  ItemsOutlineRootNode *root = [[ItemsOutlineRootNode alloc] init];
  [root addItems:items];
  [root sort];

  [self setItemsOutlineRootNode:root];
  [root release];
}

#pragma mark - addProjectSheetController

- (AddProjectSheetController *)addProjectSheetController
{
  if (!addProjectSheetController) {
    addProjectSheetController = [[AddProjectSheetController alloc] initWithWindowNibName:@"AddProjectSheet"];
    [addProjectSheetController setProjects:[[self context] projects]];
    [addProjectSheetController setDelegate:self];
  }

  return addProjectSheetController;
}

- (void)projectWasAdded:(Project *)project
{
  [context save];
  [self populateProjectPicker];
}


@end
