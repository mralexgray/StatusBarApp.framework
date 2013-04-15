/*
    MenuAppWindow.h
    
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

#import <Cocoa/Cocoa.h>
			
#import "MenuAppController.h"

@interface MenuAppWindow : NSWindow
{
    NSPoint initialLocation;
    NSPoint cursorLocation;
    NSImage *resizeImage;
    BOOL growBoxInScroll;
    BOOL canMiniaturize;
    BOOL canResize;
    BOOL canClose;
    BOOL canMove;
	
	NSView* statuesView;	//The view that this window is snapped to;
	BOOL attached;
}
@property (assign) NSView* statuesView;

- (void)setGrowBoxInScroll:(BOOL)flag;
- (void)setCanMiniaturize:(BOOL)flag;
- (void)setCanResize:(BOOL)flag;
- (void)setCanClose:(BOOL)flag;
- (void)setCanMove:(BOOL)flag;
- (BOOL)growBoxInScroll;
- (BOOL)canMiniaturize;
- (BOOL)canResize;
- (BOOL)canClose;
- (BOOL)canMove;
- (void)checkSize:(NSRect *)currentRect;
- (NSRect)_growBoxRect;
- (void)drawResizeWidgetInRect:(NSRect)resizeRect;
- (NSSize)haveDelegateCheckSize:(NSSize)aSize;
- (void)addCloseWidget;

//Checks if its snapped to a NSStatus item's view (statusView)
- (BOOL)isSnapedToWidget;
@end
