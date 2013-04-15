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

#import "MenuAppStatusItemView.h"

@implementation MenuAppStatusItemView

// Automatically create accessor methods
@synthesize startingColor;
@synthesize endingColor;
@synthesize enabled;

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
	self.enabled = YES;
    self.startingColor =	[NSColor knobColor];
    self.endingColor = [NSColor selectedKnobColor];
  }
  return self;
}

- (void)drawRect:(NSRect)rect {
  NSBezierPath * path = [NSBezierPath bezierPathWithRect:[self bounds]];
  if(endingColor == nil && self.enabled) {
	  [startingColor set];
	  [path fill];
  } else if(self.enabled) {
		NSGradient* aGradient = [[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor];
		[aGradient drawInBezierPath:path angle:270];
	}
}

- (void)setEnabled:(BOOL)vlue {
	enabled = vlue;
	[self setNeedsDisplay:YES];
	
}

- (void)dealloc {
	[startingColor release];
	[endingColor release];
	[super dealloc];
}

@end