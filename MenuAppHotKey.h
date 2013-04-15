//
//  MenuAppHotKey.h
//  MenuApp
//
//  Created by Allan Phillips on 15/11/08.
//  Copyright 2008 Thinking Code Software Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*!	@abstract The programic interface for adding a hot key to the MenuAppController for global hotkey support */
@interface MenuAppHotKey : NSObject {
	int modifierFlags;
	int identifier;
	NSString* __strong key;
	NSString* __strong name;
}
@property(assign) int modifierFlags;		//kEventParamKeyModifiers = cmdKey, shiftKey, alphaLock, optionKey, controlKey, kEventKeyModifierFnMask
@property(assign) int identifier;
@property(strong) NSString* key;
@property(strong) NSString* name;

@end
