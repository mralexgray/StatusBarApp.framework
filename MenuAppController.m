/**
 MenuApp.Framework
 Thinking Code Software Inc.
 2008
 
 Copyright (c) 2008, Thinking Code Software Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the Thinking Code Software Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "MenuAppController.h"
#import "MenuAppWindow.h"
#import "MenuAppStatusItemView.h"
#import "MenuAppHotKey.h"

@interface MenuAppController (Private)
- (void)registerHotKeys;
- (void)unRegisterHotKeys;
@end


@implementation MenuAppController
@synthesize isWindowAttached, windowLevel, statusItem, delegate, menuWindow;
@dynamic isWindowVisible, menuIconImage, menuIconAltImage, menuRightClickMenu, windowContentView, initialWindowSize, modifierKeys;

- (void)commonInit {
	self.isWindowAttached = YES;
	self.windowLevel = NSTornOffMenuWindowLevel;
	self.statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];

	if(![NSBundle loadNibNamed:@"MenuWindow" owner:self]) {
		NSAssert(NO, @"MenuAppController could not load nib named 'MenuWindow.xib'");
		return;
	}
}

- (id)init {
	if(self = [super init]) {
		[self commonInit];
	}
	return self;
}

- (void)loadStatusMenu {
	statusItemView.enabled = NO;
	statusItemView.startingColor = [NSColor lightGrayColor];
	statusItemView.endingColor = [NSColor grayColor];
	
	menuWindow.statuesView = statusItemView;	//for snapping to statusItem
	
	[self.statusItem setTitle:@"..."];
	[self.statusItem setHighlightMode:YES];
	
	[self.statusItem setView:statusItemView];
}

- (NSRect)initialWindowSize {
	return [menuWindow frame];
}

- (void)setInitialWindowSize:(NSRect)frame {
	[menuWindow setFrame:frame display:YES];
}

- (NSView*)windowContentView {
	return [menuWindow contentView];
}

- (void)setWindowContentView:(NSView*)view {
	[menuWindow setContentView:view];
}

- (NSImage*)menuIconImage {
	return [toggleButton image];
}

- (void)setMenuIconImage:(NSImage*)image {
	[toggleButton setImage:image];
}

- (NSImage*)menuIconAltImage {
	return [toggleButton alternateImage];
}

- (void)setMenuIconAltImage:(NSImage*)image {
	[toggleButton setAlternateImage:image];
}

- (NSMenu*)menuRightClickMenu {
	return [toggleButton menu];
}

- (void)setMenuRightClickMenu:(NSMenu*)menu {
	[toggleButton setMenu:menu];
}

- (void)setIsWindowAttached:(BOOL)flag {
	if(flag != isWindowAttached) {
		if(flag) {
			if(delegate && [delegate respondsToSelector:@selector(menuAppController:willAttachMenuWindow:)]) {
				[delegate menuAppController:self willAttachMenuWindow:menuWindow];
			}
		} else {
			if(delegate && [delegate respondsToSelector:@selector(menuAppController:willDetachMenuWindow:)]) {
				[delegate menuAppController:self willDetachMenuWindow:menuWindow];
			}
		}
		isWindowAttached = flag;
	}
}

- (void)showMenuWindowDetached {
	self.isWindowAttached = NO;
	statusItemView.enabled = FALSE;
	
	//a way to get window to draw properly when tore-off (FIX THIS!)
	NSRect or = [menuWindow frame];
	NSRect new = NSMakeRect(or.origin.x, or.origin.y, or.size.width + 1, or.size.height);
	[menuWindow setFrame:new display:YES];
	
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"com.thinkingcode.menuapp-framework.windowattached"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showMenuWindowAttached {
	self.isWindowAttached = YES;
	statusItemView.enabled = YES;
	NSRect wr = [menuWindow frame];
	NSPoint p = [[[statusItem view] window] convertBaseToScreen: NSMakePoint(0, 0)];
	p.y = p.y - [menuWindow frame].size.height;
	
	//Handle automatic side switching based on window size and status item placement in menubar
	NSRect sR = [[NSScreen mainScreen] frame];
	if( (sR.size.width - (p.x + wr.size.width)) < 0 ) {
		p.x = p.x - (wr.size.width - [[statusItem view] frame].size.width);
	}
	
	[menuWindow setFrameOrigin:p];
}

- (void)setIsWindowVisible:(BOOL)open {
	if(open) {
		if(delegate && [delegate respondsToSelector:@selector(menuAppController:willShowMenuWindow:)]) {
			[delegate menuAppController:self willShowMenuWindow:menuWindow];
		}
		
		BOOL isSnappedToMenuBar = [menuWindow isSnapedToWidget];
		if(isSnappedToMenuBar) statusItemView.enabled = YES;
		if(![NSApp isActive]) [NSApp activateIgnoringOtherApps:YES];
		
		if(self.isWindowAttached) [self showMenuWindowAttached];
		else [self showMenuWindowDetached];
		
		[menuWindow makeKeyAndOrderFront:nil];
		[menuWindow setLevel:self.windowLevel];
	} else {
		if(delegate && [delegate respondsToSelector:@selector(menuAppController:willHideMenuWindow:)]) {
			[delegate menuAppController:self willHideMenuWindow:menuWindow];
		}		
		
		[menuWindow orderOut: self];
		[statusItemView setEnabled:NO];
	}
}

//target/action method to toggle window visiblity.
- (IBAction)toggleMenuAppWindow:(id)sender {
	if(![menuWindow isVisible] || [[NSApplication sharedApplication] isHidden]) {
		[self setIsWindowVisible:YES];
	} else {
		[self setIsWindowVisible:NO];
	}
}

- (void)dealloc {
	[statusItem release];
	[menuWindow release];
	[statusItemView release];
	[menuWindowContent release];
	[toggleButton release];
	[super dealloc];
}

#pragma mark HotKey Support 

- (NSArray*)modifierKeys {
	return modifierKeys;
}

- (void)setModifierKeys:(NSArray*)keys {
	[self unRegisterHotKeys];
	modifierKeys = keys;
	[self registerHotKeys];
}

- (NSString*)keyForCode:(int)code {
	switch (code) {
		case 49:	return @"Space";
		case 36:	return @"Return";
		case 123:	return @"Left";
		case 124:	return @"Right";
		case 126:	return @"Up";
		case 125:	return @"Down";
		case 0:		return @"a";
		case 11:	return @"b";
		case 8:		return @"c";
		case 2:		return @"d";
		case 14:	return @"e";
		case 3:		return @"f";
		case 5:		return @"g";
		case 4:		return @"h";
		case 34:	return @"i";
		case 38:	return @"j";
		case 40:	return @"k";
		case 37:	return @"l";
		case 46:	return @"m";
		case 45:	return @"n";
		case 31:	return @"o";
		case 35:	return @"p";
		case 12:	return @"q";
		case 15:	return @"r";
		case 1:		return @"s";
		case 17:	return @"t";
		case 32:	return @"u";
		case 9:		return @"v";
		case 13:	return @"w";
		case 7:		return @"x";
		case 16:	return @"y";
		case 6:		return @"z";
		default:
			return nil;
	}
}

- (int)codeForKey:(NSString*)key {
	if([key isEqualToString:@"Space"])			return 49;
	else if([key isEqualToString:@"Return"])	return 36;
	else if([key isEqualToString:@"Left"])		return 123;
	else if([key isEqualToString:@"Right"])		return 124;
	else if([key isEqualToString:@"Up"])		return 126;
	else if([key isEqualToString:@"Down"])		return 125;
	else if([key isEqualToString:@"a"])			return 0;
	else if([key isEqualToString:@"b"])			return 11;
	else if([key isEqualToString:@"c"])			return 8;
	else if([key isEqualToString:@"d"])			return 2;
	else if([key isEqualToString:@"e"])			return 14;
	else if([key isEqualToString:@"f"])			return 3;
	else if([key isEqualToString:@"g"])			return 5;
	else if([key isEqualToString:@"h"])			return 4;
	else if([key isEqualToString:@"i"])			return 34;
	else if([key isEqualToString:@"j"])			return 38;
	else if([key isEqualToString:@"k"])			return 40;
	else if([key isEqualToString:@"l"])			return 37;
	else if([key isEqualToString:@"m"])			return 46;
	else if([key isEqualToString:@"n"])			return 45;
	else if([key isEqualToString:@"o"])			return 31;
	else if([key isEqualToString:@"p"])			return 35;
	else if([key isEqualToString:@"q"])			return 12;
	else if([key isEqualToString:@"r"])			return 15;
	else if([key isEqualToString:@"s"])			return 1;
	else if([key isEqualToString:@"t"])			return 17;
	else if([key isEqualToString:@"u"])			return 32;
	else if([key isEqualToString:@"v"])			return 9;
	else if([key isEqualToString:@"w"])			return 13;
	else if([key isEqualToString:@"x"])			return 7;
	else if([key isEqualToString:@"y"])			return 16;
	else if([key isEqualToString:@"z"])			return 6;
	else return -1;
}

//Carbon code to handle hotkeys
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData) {
	EventHotKeyID hotKeyID;
	GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyID), NULL, &hotKeyID);	
	
	int identifier = hotKeyID.id;
	
	MenuAppController* controller = userData;
	MenuAppHotKey* hotKey = nil;
	for(MenuAppHotKey* ahotKey in controller.modifierKeys) {
		if(ahotKey.identifier == identifier) {
			hotKey = ahotKey;
			break;
		}
	}
	if(!hotKey) { NSLog(@"No hotkey found!");  return noErr; }
		
	if([controller.delegate respondsToSelector:@selector(menuAppController:shouldHandleHotKey:)]) {
		[controller.delegate menuAppController:controller shouldHandleHotKey:hotKey];
	}
	return noErr;
}

/*!	@abstract	This registers all supported hotkeys with the operating system. (MenuAppHotKey) */
- (void)registerHotKeys {
	int i = 0;
	for(MenuAppHotKey* key in modifierKeys) {
		NSLog(@"REGISTERING HOTKEY:%@", key.name);
		unsigned int lengthOfName = [key.name length];
		char name[lengthOfName + 1];
		strcpy(name, [key.name UTF8String]);
		
		EventHotKeyID hotKeyID = { *name, key.identifier };
		EventTypeSpec eventType = { kEventClassKeyboard, kEventHotKeyPressed };
		
		//Register the application for the hotkey
		InstallApplicationEventHandler(&MyHotKeyHandler, 1, &eventType, self, NULL);

		if(noErr != RegisterEventHotKey([self codeForKey:key.key], key.modifierFlags, hotKeyID, GetApplicationEventTarget(), 0, &refKeys[i])) {
			NSLog(@"+++ FAILURE TO REGISTER HOTKEY +++");
			NSException* myException = [NSException
										exceptionWithName:@"MenuAppControllerCannotRegisterHotKey"
										reason:@"Attempt to register hotkey failed"
										userInfo:nil];
			@throw myException;
		}
		i++;
	}
}

- (void)unRegisterHotKeys {
	int i = 0;
	for(MenuAppHotKey* key in modifierKeys) {		
		UnregisterEventHotKey(refKeys[i]);
		i++;
	}
}

@end
