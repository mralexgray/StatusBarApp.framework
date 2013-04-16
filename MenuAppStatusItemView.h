/*!
	@class
	@abstract		Provides a custom view that draws a gradient on it's backgound
	@discussion		This view also provides a way to create a rounded top or bottom componant
					This allows for for programmic access to automatically round any given corners
*/
@interface MenuAppStatusItemView : NSView

@property(strong) NSColor *startingColor;
@property(strong) NSColor *endingColor;

/*! @abstract If not enabled, no gradient is displayed */
@property(assign, nonatomic) BOOL enabled;

@end
