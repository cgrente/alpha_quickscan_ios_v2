//
//  Draw2D.h
//  QuickScan
//
//  Created by Cliff Grente on 02/02/12.
//  Copyright (c) 2012 Archivme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImproveResizeImageViewController.h"
#import "ShareFunction.h"

typedef struct s_coord {
    CGPoint* leftUpPixelCoord;
    CGPoint* rightDownPixelCoord;
    float imgHeight;
    float imgWidth;
} t_coord;

@interface Draw2D : UIView {
    t_coord* savePos;
    UIImage* imgOutput;
   // UIView* zoomOnSelectedCornerView;
}

-(id)initWithFrame:(CGRect)frame:(void*)saveCoord;



@end
