
#import "MenuAppStatusItemView.h"

@implementation MenuAppStatusItemView
@synthesize startingColor, endingColor;

- (id) initWithFrame:(NSRect)frame 	{
	if (self != [super initWithFrame:frame]) return nil;
	self.enabled = YES;
   self.startingColor =	[NSColor knobColor];
   self.endingColor = [NSColor selectedKnobColor];
  	return self;
}

- (void) drawRect:	(NSRect) rect 	{

  NSBezierPath * path = [NSBezierPath bezierPathWithRect:self.bounds];

  endingColor == nil && self.enabled ? ^{	  [startingColor set];	  [path fill];  }():
								self.enabled ?

	[[NSGradient.alloc initWithStartingColor:startingColor endingColor:endingColor]
								   drawInBezierPath:path angle:270] : nil;

}

- (void) setEnabled: (BOOL)  vlue	{	_enabled = vlue;	[self setNeedsDisplay:YES];	}

@end
