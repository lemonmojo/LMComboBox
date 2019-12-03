//
//  AppDelegate.m
//  LMComboBox
//
//  Created by Felix Deimel on 29.05.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Set up Items for the Combo Box
    
    NSDictionary* sepa1 = @{ @"isSeparator": @YES,
                             @"title": @"Apple Products" };
    
    NSDictionary* item1 = @{ @"isSeparator": @NO,
                             @"title": @"MacBook Pro" };
    
    NSDictionary* item2 = @{ @"isSeparator": @NO,
                             @"title": @"iMac" };
    
    NSDictionary* item3 = @{ @"isSeparator": @NO,
                             @"title": @"iPhone" };
    
    NSDictionary* item4 = @{ @"isSeparator": @NO,
                             @"title": @"iPad" };
    
    NSDictionary* sepa2 = @{ @"isSeparator": @YES,
                             @"title": @"Google Products" };
    
    NSDictionary* item5 = @{ @"isSeparator": @NO,
                             @"title": @"Nexus 7" };
    
    NSDictionary* item6 = @{ @"isSeparator": @NO,
                             @"title": @"Chromebook Pixel" };
    
    NSMutableArray* items = [[@[ sepa1, item1, item2, item3, item4, sepa2, item5, item6 ] mutableCopy] autorelease];
    
    self.comboBoxArrayController.content = items;
    
    // This class is also the delegate for the Combo Box's Table View
    self.comboBox.tableViewDelegate = self;
}

- (IBAction)buttonRemoveSelectedItem_action:(id)sender {
    NSInteger selIdx = self.comboBox.indexOfSelectedItem;
    
    if (selIdx == NSNotFound ||
        selIdx < 0) {
        return;
    }
    
    [self.comboBoxArrayController removeObjectAtArrangedObjectIndex:selIdx];
    
    self.comboBox.stringValue = @"";
}

- (NSDictionary*)itemAtIndex:(NSInteger)index {
    // Return an item from a specific position in the Array Controller
    
    self.comboBoxArrayController.selectionIndex = index;
    
    NSArray* selectedObjects = self.comboBoxArrayController.selectedObjects;
    
    NSDictionary* item = nil;
    
    if (selectedObjects &&
        selectedObjects.count > 0) {
        item = selectedObjects[0];
    }
    
    return item;
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    // Making customizations to the drawing
    
    NSDictionary* item = [self itemAtIndex:rowIndex];
    
    BOOL isSeparator = [item[@"isSeparator"] boolValue];
    
    NSTextFieldCell* txtCell = (NSTextFieldCell*)aCell;
    NSString* cellStr = txtCell.stringValue;
    
    txtCell.enabled = !isSeparator;
    txtCell.selectable = NO;
    txtCell.textColor = isSeparator ? NSColor.disabledControlTextColor : NSColor.controlTextColor;
    
    if (isSeparator) {
        NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle.defaultParagraphStyle.mutableCopy autorelease];
        
        paragraphStyle.alignment = NSCenterTextAlignment;
        
        NSDictionary* attributes = @{ NSObliquenessAttributeName: @0.20f,
                                      NSParagraphStyleAttributeName: paragraphStyle };
        
        NSAttributedString* txtA = [[[NSAttributedString alloc] initWithString:cellStr attributes:attributes] autorelease];
        
        txtCell.attributedStringValue = txtA;
    }
}

// You have to implement this if you want to be able to modify (add/remove items) the content of the ComboBox
- (void)_numberOfRowsDidChangeInComboBoxTableView:(NSTableView *)aTableView {
    
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    // Separator items should not be selectable
    
    NSDictionary* item = [self itemAtIndex:rowIndex];
    BOOL isSeparator = [item[@"isSeparator"] boolValue];
    
    return !isSeparator;
}

@end
