//
//  Draw2D.m
//  QuickScan
//
//  Created by Cliff Grente on 02/02/12.
//  Copyright (c) 2012 Archivme. All rights reserved.
//

#import "ImproveResizeImageViewController.h"
#import "Draw2D.h"

@implementation Draw2D

-(id)initWithFrame:(CGRect)frame:(void*)saveCoord {
    self = [super initWithFrame:frame];
    if (self) {
        savePos = saveCoord;
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextBeginPath(context);
    
    NSLog(@"draw two line");
    
    NSLog(@"leftUp Pixel - === - %f %f",((210./720.)* savePos->leftUpPixelCoord->x), ((297./960.)*savePos->leftUpPixelCoord->y) );
    NSLog(@"leftUp Pixel - === - %f %f", ((210./720.)* savePos->leftUpPixelCoord->x), ((297./960.)*savePos->rightDownPixelCoord->y));

    
    CGContextMoveToPoint(context, ((210./savePos->imgWidth)* savePos->leftUpPixelCoord->x), ((297./savePos->imgHeight)*savePos->leftUpPixelCoord->y));
    CGContextAddLineToPoint(context, ((210./savePos->imgWidth)* savePos->rightDownPixelCoord->x), ((297./savePos->imgHeight)*savePos->leftUpPixelCoord->y));
    CGContextMoveToPoint(context, ((210./savePos->imgWidth)* savePos->leftUpPixelCoord->x), ((297./savePos->imgHeight)*savePos->leftUpPixelCoord->y));
    CGContextAddLineToPoint(context, ((210./savePos->imgWidth)* savePos->leftUpPixelCoord->x), ((297./savePos->imgHeight)*savePos->rightDownPixelCoord->y));
    
    NSLog(@"draw two more line");
    
    CGContextMoveToPoint(context, ((210./savePos->imgWidth)* savePos->rightDownPixelCoord->x), ((297./savePos->imgHeight)*savePos->rightDownPixelCoord->y));
    CGContextAddLineToPoint(context, ((210./savePos->imgWidth)* savePos->rightDownPixelCoord->x), ((297./savePos->imgHeight)*savePos->leftUpPixelCoord->y));
    CGContextMoveToPoint(context, ((210./savePos->imgWidth)* savePos->rightDownPixelCoord->x), ((297./savePos->imgHeight)*savePos->rightDownPixelCoord->y));
    CGContextAddLineToPoint(context, ((210./savePos->imgWidth)* savePos->leftUpPixelCoord->x), ((297./savePos->imgHeight)*savePos->rightDownPixelCoord->y));

    CGContextStrokePath(context);
    
}

@end
