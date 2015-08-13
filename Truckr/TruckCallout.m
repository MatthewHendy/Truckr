//
//  TruckCallout.m
//  Truckr
//
//  Created by Mac OS on 7/2/15.
//  Copyright (c) 2015 Matthew Hendrickson. All rights reserved.
//

#import "TruckCallout.h"

@implementation TruckCallout

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)fav:(id)sender {
    NSLog(@"fnhdjbdhjbdhfbdhbfdjhfbfav button pressed");
}


/*
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    NSLog(@"here 1");
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    NSLog(@"here 2");

    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}
*/

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"init'd callout");
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.favoriteButton  action:@selector(fav:)];

    
    
    return self;
}

@end
