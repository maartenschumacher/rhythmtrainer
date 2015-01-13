//
//  Melody.h
//  openaltest
//
//  Created by Maarten Schumacher on 10/3/14.
//  Copyright (c) 2014 Maarten Schumacher. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Melody : NSObject

-(float)getPitchForTime: (NSInteger)clickedTime WithMeter:(NSInteger)meter;

@end
