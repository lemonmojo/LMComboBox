//
//  LMComboBox.h
//  LMComboBox
//
//  Created by Felix Deimel on 29.05.13.
//  Copyright (c) 2013 Lemon Mojo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LMComboBox : NSComboBox<NSTableViewDelegate> {
    BOOL m_isPopUpOpen;
    id<NSTableViewDelegate> tableViewDelegate;
}

@property (nonatomic, retain) id<NSTableViewDelegate> tableViewDelegate;

@end
