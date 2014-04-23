//
//  MapPin.h
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-30.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;

@end
