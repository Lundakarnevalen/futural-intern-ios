//
//  MapPin.m
//  Karnevalisten
//
//  Created by Richard Luong on 2014-03-30.
//  Copyright (c) 2014 Lundakarnevalen. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location {
    self = [super init];
    
    if (self) {
        self.title = newTitle;
        self.coordinate = location;
    }
    
    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MapPin"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"Moln"];
    
    return annotationView;
}


@end
