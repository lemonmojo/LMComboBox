//
//  LMComboBox.m
//  LMComboBox
//
//  Created by Felix Deimel on 29.05.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "LMComboBox.h"

@implementation LMComboBox

@synthesize tableViewDelegate;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
		[self awakeFromNib];
    }
    
    return self;
}

- (void)awakeFromNib {
    m_isPopUpOpen = NO;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willPopUp:)
												 name:NSComboBoxWillPopUpNotification
											   object:self];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(willDismiss:)
												 name:NSComboBoxWillDismissNotification
											   object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (tableViewDelegate) {
        [tableViewDelegate release];
        tableViewDelegate = nil;
    }
    
    [super dealloc];
}

- (NSWindow *)comboBoxPopUpWindow {
	NSWindow *child = nil;
    
	if (m_isPopUpOpen) {
		for (child in [[self window] childWindows]) {
			if ([[child className] isEqualToString:@"NSComboBoxWindow"]) {
				break;
			}
		}
	}
    
	return child;
}

- (void)drawRect:(NSRect)dirtyRect {
	if (m_isPopUpOpen) {
		[self setTableViewDelegate];
    }
    
    [super drawRect:dirtyRect];
}

- (void)willPopUp:(NSNotification *)notification {
	m_isPopUpOpen = YES;
}

- (void)willDismiss:(NSNotification *)notification {
	m_isPopUpOpen = NO;
}

- (void)setTableViewDelegate
{
    NSWindow *popUpWindow = [self comboBoxPopUpWindow];
    
    NSTableView* tv = nil;
    
    for (NSView* subView1 in ((NSView*)popUpWindow.contentView).subviews) {
        if (subView1.class == [NSClipView class]) {
            for (NSView* subView2 in subView1.subviews) {
                if ([subView2.class isSubclassOfClass:[NSTableView class]]) {
                    tv = (NSTableView*)subView2;
                    
                    break;
                }
            }
            
            break;
        }
    }
    
    if (tv &&
        tv.delegate != tableViewDelegate) {
        tv.delegate = tableViewDelegate;
        [tv reloadData];
    }
}

@end
