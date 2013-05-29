//
//  AppDelegate.h
//  LMComboBox
//
//  Created by Felix Deimel on 29.05.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LMComboBox.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate> {
    LMComboBox *comboBox;
    NSArrayController *comboBoxArrayController;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet LMComboBox *comboBox;
@property (assign) IBOutlet NSArrayController *comboBoxArrayController;

- (NSDictionary*)itemAtIndex:(NSInteger)index;

@end
