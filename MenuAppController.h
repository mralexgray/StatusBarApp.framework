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

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
@class MenuAppWindow;
@class MenuAppHotKey;
@class MenuAppStatusItemView;

@interface MenuAppController : NSObject {
	id __strong delegate;							//The MenuAppDelegate
	NSStatusItem * __strong statusItem;				//The NSStatusItem that toggles the menu app display
	MenuAppWindow * __strong menuWindow;				//The menu's window that gets shown (attached to menu)
	MenuAppStatusItemView * statusItemView;	//The view that gets displayed in the menubar (acts as button)
	NSView * menuWindowContent;				//User supplied content that gets drawn in the window.
	BOOL isWindowAttached;
	
	NSInteger windowLevel;					//The on screen window level for the menu window. (Defualt is NSTornOffMenuWindowLevel)
	
	IBOutlet NSButton * toggleButton;		//The button embeded in the statusItem's view for toggleing window
	NSArray* modifierKeys;					//An array of MenuAppHotKey's used to setup global hotkey support
	EventHotKeyRef refKeys[100];
}
@property (strong) id delegate;
@property (strong) MenuAppWindow * menuWindow;
@property (strong) NSStatusItem * statusItem;
@property (strong) NSImage* menuIconImage;
@property (strong) NSImage* menuIconAltImage;
@property (strong) NSMenu* menuRightClickMenu;
@property (strong) NSArray* modifierKeys;

/*!	@abstract The content that gets placed in the pulloff window */
@property (strong) NSView* windowContentView;

@property (assign) NSRect initialWindowSize;

@property (assign) BOOL isWindowAttached;
@property (assign) NSInteger windowLevel;

/*!	@abstract	Indicates/Sets the menuApp window's visiblity */
@property (assign) BOOL isWindowVisible;

/*!	@abstract	Loads the statusmenu, creating the window/status item and setting it up */
- (void)loadStatusMenu;

- (IBAction)toggleMenuAppWindow:(id)sender;

@end

@interface NSObject (MenuAppDelegate)
- (void)menuAppController:(MenuAppController*)controller shouldHandleHotKey:(MenuAppHotKey*)event;
- (void)menuAppController:(MenuAppController*)controller willShowMenuWindow:(NSWindow*)window;
- (void)menuAppController:(MenuAppController*)controller willHideMenuWindow:(NSWindow*)window;
- (void)menuAppController:(MenuAppController*)controller willDetachMenuWindow:(NSWindow*)window;
- (void)menuAppController:(MenuAppController*)controller willAttachMenuWindow:(NSWindow*)window;
@end
