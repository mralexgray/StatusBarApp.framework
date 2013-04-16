/*
 MenuAppWindow.m
 
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
 
#import "MenuAppWindow.h"

static BOOL resizing=NO;

@implementation MenuAppWindow
@synthesize statuesView, canClose, canMiniaturize, canResize, canMove, growBoxInScroll;

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if (self != [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag]) return nil;
	self.canMove 			= YES;
	self.growBoxInScroll = YES;
	self.canResize			= YES;
	self.canClose			= NO;
	self.minSize 			= NSMakeSize(100, 100);
	attached 				= YES;
	//	[self addCloseWidget];
	return self;
}


- (NSString *)miniwindowTitle
{
    return [self title];
}

- (BOOL)setFrameUsingName:(NSString *)name
{
    return [self setFrameUsingName:name force:YES];
}

- (void)orderOut:(id)sender
{
    if (resizeImage) {
	resizeImage=nil;
    }
    [super orderOut:sender];
}

/*  This will add the window to the window list - 
    it will only be added *after* the window is visible
    so we do it in orderFront and makeKeyAndOrderFront
*/
- (void)orderFront:(id)sender
{
    [super orderFront:sender];
    if (![self isExcludedFromWindowsMenu]) {
	[NSApp changeWindowsItem:self title:[self title] filename:NO];
    }
    [self drawResizeWidgetInRect:[self _growBoxRect]];
}

- (void)makeKeyAndOrderFront:(id)sender
{
    [super makeKeyAndOrderFront:sender];
    if (![self isExcludedFromWindowsMenu]) {
		[NSApp changeWindowsItem:self title:[self title] filename:NO];
    }
    [self drawResizeWidgetInRect:[self _growBoxRect]];
}

/* this is an internal NSWindow method.
   I can't gaurantee that it will always work,
   just that it works for now.
   This will, for now, let objects know
   there's a resize box to take account of.
*/
- (NSRect)_growBoxRect
{
    if (canResize) {
		return NSMakeRect([self frame].size.width - 16, 0, 16, 16);
    }
    return NSMakeRect(0,0,0,0);
}
    
-(void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation;
    NSRect windowFrame = [self frame];
    
    currentLocation = [NSEvent mouseLocation];
    
    if ((resizing || NSMouseInRect(initialLocation, [self _growBoxRect], NO)) && canResize) {
		NSRect newFrame;
		float newWidth;
		resizing=YES;
		currentLocation.x -= windowFrame.origin.x;
		currentLocation.y -= windowFrame.origin.y;
		newWidth = windowFrame.size.width - (initialLocation.x - currentLocation.x);
		newFrame.size.width = newWidth;
		newFrame.size.height = (windowFrame.size.height - currentLocation.y) + cursorLocation.y;
		[self checkSize:&newFrame];
		if ([[self delegate] respondsToSelector:@selector(windowWillResize:toSize:)]) {
			newFrame.size = [self haveDelegateCheckSize:newFrame.size];
		}
		newFrame.origin = NSMakePoint(NSMinX(windowFrame), NSMaxY(windowFrame) - NSHeight(newFrame));
		if (NSEqualRects(windowFrame, newFrame)) {
			return;
		}
		[self setFrame:newFrame display:YES];
		[self drawResizeWidgetInRect:[self _growBoxRect]];
		if (newWidth >= [self minSize].width) {
			initialLocation = currentLocation;
		} else {
			initialLocation.x = [self minSize].width - cursorLocation.x;
			initialLocation.y = currentLocation.y;
		}
    } else if (canMove) { /** add snap to dejumble icon here **/
		NSPoint newOrigin;
		newOrigin.x = currentLocation.x - initialLocation.x;
		newOrigin.y = currentLocation.y - initialLocation.y;
		
		//Snapp to button and notifications
		//Snapping conditions
		NSPoint sp = [[statuesView window] convertBaseToScreen: NSMakePoint(0, 0)];
		float menuBarHieght = [[[NSApplication sharedApplication] mainMenu] menuBarHeight];
		//TODO: Snapping
		if ([[NSScreen screens][0] isEqual:[self screen]]
			&& ((newOrigin.y + [self frame].size.height) > [[self screen] frame].size.height - (menuBarHieght + 5))) {
			newOrigin.y = [[self screen] frame].size.height - menuBarHieght - [self frame].size.height;
			BOOL willSnap = NO;
			
			//Snap to NSMenuItem <-- key feature of this class
			if	( (newOrigin.x > (sp.x-30) && newOrigin.x < (sp.x+30)) ) { //left side.
				willSnap = YES;
				newOrigin.x = sp.x;
			} else if (newOrigin.x+[self frame].size.width < sp.x+60 && newOrigin.x+[self frame].size.width > sp.x-5) {
				willSnap = YES;
				newOrigin.x = sp.x + [statuesView bounds].size.width - [self frame].size.width;
			} else {
				if(!attached) {
					attached = YES;
					willSnap = NO;
					[((NSObject*)[self delegate]) showMenuWindowDetached];
				}
			}
			
			//Do the actual attaching
			if(attached && willSnap) { 
				attached = NO;
				[((NSObject*)[self delegate]) showMenuWindowAttached];
			}
			
		} else {
			if(!attached) {
				attached = YES;
				[((NSObject*)[self delegate]) showMenuWindowDetached];
			}
		}
		
		[self setFrameOrigin:newOrigin];
    }
}

-(void)mouseDown:(NSEvent *)theEvent
{
    if ([theEvent clickCount] == 2 && canMiniaturize) {
		[self miniaturize:self];
    }
    initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
    cursorLocation = [theEvent locationInWindow];
    cursorLocation.x = ([self frame].size.width - cursorLocation.x);
    initialLocation.x -= [self frame].origin.x;
    initialLocation.y -= [self frame].origin.y;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (resizing) {
	if (![[self frameAutosaveName] isEqualToString:@""]) {
	    [self saveFrameUsingName:[self frameAutosaveName]];
	}
		resizing=NO;
    }
}

- (void)performClose:(id)sender
{
    [self close];
}

- (void)performMiniaturize:(id)sender
{
    [self miniaturize:sender];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    SEL action = [menuItem action];
    
    if (action == @selector(performClose:) && canClose) {
	return YES;
    } else if (action == @selector(performMiniaturize:) && canMiniaturize) {
	return YES;
    }
    return [super validateMenuItem:menuItem];
}

- (NSSize)haveDelegateCheckSize:(NSSize)aSize
{
    NSInvocation *resizeInv=[NSInvocation invocationWithMethodSignature:[((NSObject*)[self delegate]) methodSignatureForSelector:@selector(windowWillResize:toSize:)]];
    NSSize newSize;
    NSPoint convertedPoint;
    //NSWindow's reference says the size sent is in screen coordinates,
    //so we need to convert to that first.
    convertedPoint.x = aSize.width;
    convertedPoint.y = aSize.height;
    convertedPoint = [self convertBaseToScreen:convertedPoint];
    newSize.width=convertedPoint.x;
    newSize.height=convertedPoint.y;
    [resizeInv setTarget:[self delegate]];
    [resizeInv setSelector:@selector(windowWillResize:toSize:)];
    [resizeInv setArgument:(__bridge void *)(self) atIndex:2];
    [resizeInv setArgument:&newSize atIndex:3];
    [resizeInv invoke];
    [resizeInv getReturnValue:&newSize];
    convertedPoint.x = newSize.width;
    convertedPoint.y = newSize.height;
    convertedPoint = [self convertScreenToBase:convertedPoint];
    newSize.width = convertedPoint.x;
    newSize.height = convertedPoint.y;
    return newSize;
}

- (void)checkSize:(NSRect *)currentRect
{
    if (currentRect->size.width < [self minSize].width) {
	currentRect->size.width = [self minSize].width;
    }
    if (currentRect->size.height < [self minSize].height) {
	currentRect->size.height = [self minSize].height;
    }
    if (currentRect->size.width > [self maxSize].width) {
	currentRect->size.width = [self maxSize].width;
    }
    if (currentRect->size.height > [self maxSize].height) {
	currentRect->size.height = [self maxSize].height;
    }
    //constrain it to the current screen
    if ((currentRect->origin.x + currentRect->size.width) > [[self screen]frame].size.width) {
	currentRect->size.width = ([[self screen]frame].size.width - currentRect->origin.x);
    }
    if ((NSMaxY([self frame]) - NSHeight(*currentRect)) < [[self screen]frame].origin.y) {
	currentRect->size.height = [self frame].size.height;
    }
}

- (void)drawResizeWidgetInRect:(NSRect)resizeRect
{
    if (!canResize) {
	return;
    }
    if (resizeImage) {
	[self disableFlushWindow];
	[[self contentView] lockFocus];
	[resizeImage compositeToPoint:NSMakePoint(resizeRect.origin.x,resizeRect.origin.y) operation:NSCompositeSourceOver];
	[[self contentView] unlockFocus];
	[self enableFlushWindow];
	[self flushWindowIfNeeded];
    } else {
	float line1size1 = (resizeRect.size.height / 3.56);
	float line1size2 = (resizeRect.size.height / 1.882);
	float line1size3 = (resizeRect.size.height / 1.28);
	float rectWidth = resizeRect.size.width;
	
	resizeImage=[[NSImage alloc]initWithSize:NSMakeSize(resizeRect.size.width, resizeRect.size.height)];
	[resizeImage setScalesWhenResized:NO];
	
	[resizeImage lockFocus];
	[NSBezierPath setDefaultLineCapStyle:NSButtLineCapStyle];
	[NSBezierPath setDefaultLineWidth:0.0];
	
	if (growBoxInScroll) {
	    [[NSColor colorWithCalibratedWhite:0.65 alpha:0.9] set];
	    [NSBezierPath strokeLineFromPoint:NSMakePoint(0,0) toPoint:NSMakePoint(0,resizeRect.size.height)];
	    [NSBezierPath strokeLineFromPoint:NSMakePoint(0,resizeRect.size.height) toPoint:NSMakePoint(resizeRect.size.height,resizeRect.size.width)];
	}
	
	[[NSColor colorWithCalibratedWhite:0.45 alpha:0.9] set];
	[NSBezierPath strokeLineFromPoint:NSMakePoint((resizeRect.size.height - line1size3), 2.5) toPoint:NSMakePoint(rectWidth - 2.5, line1size3 - .75)];
	[NSBezierPath strokeLineFromPoint:NSMakePoint((resizeRect.size.height - line1size2), 2.5) toPoint:NSMakePoint(rectWidth - 2.5, line1size2 - .75)];
	[NSBezierPath strokeLineFromPoint:NSMakePoint((resizeRect.size.height - line1size1), 2.5) toPoint:NSMakePoint(rectWidth - 2.5, line1size1 - .75)];
	
	[resizeImage unlockFocus];
	
	[self disableFlushWindow];
	[[self contentView] lockFocus];
	[resizeImage compositeToPoint:NSMakePoint(resizeRect.origin.x,resizeRect.origin.y) operation:NSCompositeSourceOver];
	[[self contentView] unlockFocus];
	[self enableFlushWindow];
	[self flushWindow];
    }
}

- (void)addCloseWidget
{
    NSButton *closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(3.0, [self frame].size.height - 16.0, 
                                                                       13.0, 13.0)];
    
    [[self contentView] addSubview:closeButton];
    [closeButton setBezelStyle:NSRoundedBezelStyle];
    [closeButton setButtonType:NSMomentaryChangeButton];
    [closeButton setBordered:NO];
    [closeButton setImage:[NSImage imageNamed:@"hud_titlebar-close"]];
    [closeButton setTitle:@""];
    [closeButton setImagePosition:NSImageBelow];
    [closeButton setTarget:self];
    [closeButton setFocusRingType:NSFocusRingTypeNone];
    [closeButton setAction:@selector(orderOut:)];
}

- (BOOL)isSnapedToWidget {
	NSPoint sp = [[statuesView window] convertBaseToScreen: NSMakePoint(0, 0)];
	NSPoint newOrigin = [self frame].origin;
	float menuBarHieght = [[[NSApplication sharedApplication] mainMenu] menuBarHeight];

	if ([[NSScreen screens][0] isEqual:[self screen]] //check that we have the right screen
			&& (([self frame].origin.y + [self frame].size.height) > [[self screen] frame].size.height - (menuBarHieght + 5)) //Top
			&& ( (newOrigin.x > (sp.x-30) && newOrigin.x < (sp.x+30))  //left side.
			|| ( newOrigin.x+[self frame].size.width < sp.x+60 && newOrigin.x+[self frame].size.width > sp.x-5) ) ) //rightside
	{
		return true;
	} else {
		return false;
	}
}

@end
