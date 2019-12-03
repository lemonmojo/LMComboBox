//
//  LMComboBox.m
//  LMComboBox
//
//  Created by Felix Deimel on 29.05.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import "LMComboBox.h"

@implementation LMComboBox {
    BOOL m_isPopUpOpen;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
		[self awakeFromNib];
    }
    
    return self;
}

- (void)awakeFromNib {
    m_isPopUpOpen = NO;
    
    NSNotificationCenter* notificationCenter = NSNotificationCenter.defaultCenter;
    
	[notificationCenter addObserver:self
                           selector:@selector(willPopUp:)
                               name:NSComboBoxWillPopUpNotification
                             object:self];
    
	[notificationCenter addObserver:self
                           selector:@selector(willDismiss:)
                               name:NSComboBoxWillDismissNotification
                             object:self];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    if (self.tableViewDelegate) {
        [self.tableViewDelegate release]; self.tableViewDelegate = nil;
    }
    
    [super dealloc];
}

- (NSWindow *)comboBoxPopUpWindow {
	NSWindow *child = nil;
    
	if (m_isPopUpOpen) {
		for (child in self.window.childWindows) {
			if ([child.className isEqualToString:@"NSComboBoxWindow"]) {
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

- (NSClipView*)clipViewOfPopUpWindow:(NSWindow*)popUpWindow {
    for (NSView* subView1 in ((NSView*)popUpWindow.contentView).subviews) {
        if (subView1.class == NSClipView.class) {
            return (NSClipView*)subView1;
        } else if (subView1.class == NSScrollView.class) {
            NSScrollView* scrollView = (NSScrollView*)subView1;
            
            return scrollView.contentView;
        }
    }
    
    return nil;
}

- (void)setTableViewDelegate {
    NSWindow *popUpWindow = self.comboBoxPopUpWindow;
    
    NSTableView* tv = nil;
    
    NSClipView* clipView = [self clipViewOfPopUpWindow:popUpWindow];
    
    if (clipView) {
        for (NSView* subView in clipView.subviews) {
            if ([subView.class isSubclassOfClass:NSTableView.class]) {
                tv = (NSTableView*)subView;
                
                break;
            }
        }
    }
    
    if (tv &&
        tv.delegate != self.tableViewDelegate) {
        tv.delegate = self.tableViewDelegate;
        
        [tv reloadData];
    }
}

@end
