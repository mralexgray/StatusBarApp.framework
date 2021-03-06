#import "MenuAppController.h"

@interface NSObject (DelegateMethods)
- (void)showMenuWindowAttached;
- (void)showMenuWindowDetached;
@end
@interface MenuAppWindow : NSWindow
{
   NSPoint initialLocation, cursorLocation;
   NSImage *resizeImage;
	NSView* __strong statuesView;	//The view that this window is snapped to;
	BOOL attached;
}
@property (strong) NSView* statuesView;
@property (assign) BOOL growBoxInScroll, canMiniaturize, setCanResize, canClose,canMove, canResize;

- (void) checkSize:					(NSRect*)currentRect;
- (NSRect)_growBoxRect;
- (void) drawResizeWidgetInRect: (NSRect)resizeRect;
- (NSSize) haveDelegateCheckSize:(NSSize)aSize;
- (void) addCloseWidget;

//Checks if its snapped to a NSStatus item's view (statusView)
- (BOOL)isSnapedToWidget;
@end


/*	MenuAppWindow
 Modifications by Thinking Code Software Inc.
 Originally as DSResizableBorderlessWindow
 Original Copyright (c) 2004 Night Productions, by Darkshadow.  All Rights Reserved.
 http://homepage.mac.com/darkshadow02/developer.htm
 darkshadow02@mac.com
 May be used freely, but keep my name/copyright in the header.
 There is NO warranty of any kind, express or implied; use at your own risk.
 Responsibility for damages (if any) to anyone resulting from the use of this
 code rests entirely with the user.
 */

