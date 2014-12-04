//
//  AsyncVideoDetailPanel.m
//  YoutubePlayApp
//
//  Created by djzhang on 10/14/14.
//  Copyright (c) 2014 djzhang. All rights reserved.
//

#import "AsyncVideoDetailPanel.h"
#import "YoutubeVideoCache.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import <AsyncDisplayKit/ASHighlightOverlayLayer.h>


static CGFloat kTextPadding = 10.0f;
static NSString * kLinkAttributeName = @"PlaceKittenNodeLinkAttributeName";


@interface AsyncVideoDetailPanel ()<ASTextNodeDelegate> {
   ASTextNode * _textNode;
}

@end


@implementation AsyncVideoDetailPanel


- (instancetype)initWithVideo:(YoutubeVideoCache *)videoCache {
   if (!(self = [super init]))
      return nil;

   self.backgroundColor = [UIColor whiteColor];

   // create a text node
   _textNode = [[ASTextNode alloc] init];

   // configure the node to support tappable links
   _textNode.delegate = self;
   _textNode.userInteractionEnabled = YES;
   _textNode.linkAttributeNames = @[ kLinkAttributeName ];

   // generate an attributed string using the custom link attribute specified above
//   NSString * blurb = @"kittens courtesy placekitten.com kittens courtesy placekitten.com kittens courtesy placekitten.com \U0001F638";
   NSString * blurb = videoCache.snippet.descriptionString;
   NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:blurb];
   [string addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]
                  range:NSMakeRange(0, blurb.length)];
   [string addAttributes:@{
     kLinkAttributeName : [NSURL URLWithString:@"http://placekitten.com/"],
     NSForegroundColorAttributeName : [UIColor grayColor],
     NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternDot),
    }
                   range:[blurb rangeOfString:@"placekitten.com"]];
   _textNode.attributedString = string;

   // add it as a subnode, and we're done
   [self addSubnode:_textNode];

   return self;
}


- (void)didLoad {
   // enable highlighting now that self.layer has loaded -- see ASHighlightOverlayLayer.h
   self.layer.as_allowsHighlightDrawing = YES;

   [super didLoad];
}


- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
   // called on a background thread.  custom nodes must call -measure: on their subnodes in -calculateSizeThatFits:
   CGSize measuredSize = [_textNode measure:CGSizeMake(constrainedSize.width - 2 * kTextPadding,
    constrainedSize.height - 2 * kTextPadding)];
   return CGSizeMake(constrainedSize.width, measuredSize.height + 2 * kTextPadding);
}


- (void)layout {
   // called on the main thread.  we'll use the stashed size from above, instead of blocking on text sizing
   CGSize textNodeSize = _textNode.calculatedSize;
   _textNode.frame = CGRectMake(roundf((self.calculatedSize.width - textNodeSize.width) / 2.0f),
    kTextPadding,
    textNodeSize.width,
    textNodeSize.height);
}


- (BOOL)textNode:(ASTextNode *)richTextNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point {
   // opt into link highlighting -- tap and hold the link to try it!  must enable highlighting on a layer, see -didLoad
   return YES;
}


- (void)textNode:(ASTextNode *)richTextNode tappedLinkAttribute:(NSString *)attribute value:(NSURL *)URL atPoint:(CGPoint)point textRange:(NSRange)textRange {
   // the node tapped a link, open it
   [[UIApplication sharedApplication] openURL:URL];
}


@end
