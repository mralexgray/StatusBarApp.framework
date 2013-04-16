

@class MenuAppWindow, MenuAppHotKey, MenuAppStatusItemView, AtoZ;

@interface MenuAppController : NSObject {
	id 						 __strong delegate;	//	The MenuAppDelegate
	NSStatusItem 		* __strong statusItem;	//	The NSStatusItem that toggles the menu app display
	MenuAppWindow 		* __strong menuWindow;	//	The menu's window that gets shown (attached to menu)
	MenuAppStatusItemView  * statusItemView;	//	The view that gets displayed in the menubar (acts as button)
	NSView 				*   menuWindowContent;	// User supplied content that gets drawn in the window.
	BOOL 					     isWindowAttached;
	NSInteger 					    windowLevel; 	// Window lev for the menu win. (Defualt NSTornOffMenuWindowLevel)
	IBOutlet NSButton * 			toggleButton;	//	The button embeded in the statusItem's view for toggleing window
	NSArray				* 			modifierKeys;	//	An array of MenuAppHotKey's used to setup global hotkey support
	EventHotKeyRef 	  			refKeys[100];
}
@property (strong)	AtoZ 				 *atoz;
@property (strong)	NSBundle  *atozbundle;
@property (strong)	Class 		atozclass;
@property (strong)	NSArray  *atozmethods;


@property (strong) id delegate;
@property (strong) MenuAppWindow * 			 menuWindow;
@property (strong) NSStatusItem 	* 			 statusItem;
@property (strong) NSImage			* 		 menuIconImage;
@property (strong) NSImage			* 	 menuIconAltImage;
@property (strong) NSMenu			* menuRightClickMenu;
@property (strong) NSArray			* 		  modifierKeys;
/*!	@abstract The content that gets placed in the pulloff window */
@property (strong) NSView			* 	windowContentView;
@property (assign) NSRect 			  	initialWindowSize;
@property (assign, nonatomic) BOOL 			  	 isWindowAttached;
@property (assign) NSInteger 		 		   windowLevel;
/*!	@abstract	Indicates/Sets the menuApp window's visiblity */
@property (assign) BOOL 			  	  isWindowVisible;
/*!	@abstract	Loads the statusmenu, creating the window/status item and setting it up */
- (void) loadStatusMenu;
- (IBAction) toggleMenuAppWindow:(id)sender;
@end

@interface NSObject (MenuAppDelegate)
- (void)menuAppController:(MenuAppController*)controller shouldHandleHotKey:  (MenuAppHotKey*)event;
- (void)menuAppController:(MenuAppController*)controller willShowMenuWindow:  (NSWindow*)window;
- (void)menuAppController:(MenuAppController*)controller willHideMenuWindow:  (NSWindow*)window;
- (void)menuAppController:(MenuAppController*)controller willDetachMenuWindow:(NSWindow*)window;
- (void)menuAppController:(MenuAppController*)controller willAttachMenuWindow:(NSWindow*)window;
@end
