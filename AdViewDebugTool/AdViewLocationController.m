//
//  AdViewLocationController.m
//  AdViewSDK_Sample
//
//  Copyright 2010 www.adview.cn. All rights reserved.
//

#import "AdViewLocationController.h"
#import "AdViewLog.h"

#define LOCVIEW_LOCLABEL_OFFSET 79
#define LOCVIEW_LABEL_OFFSET 87
#define LOCVIEW_LABEL_HDIFF 63

@implementation AdViewLocationController

- (id)init {
  if (self = [super initWithNibName:@"AdViewLocationController" bundle:nil]) {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    currLayoutOrientation = UIInterfaceOrientationPortrait; // nib file defines a portrait view
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self adjustLayoutToOrientation:self.interfaceOrientation];
}

- (UILabel *)locLabel {
  return (UILabel *)[self.view viewWithTag:103];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration {
  [self adjustLayoutToOrientation:interfaceOrientation];
}

- (void)adjustLayoutToOrientation:(UIInterfaceOrientation)newOrientation {
  UILabel *ll = self.locLabel;
  UILabel *label = self.label;
  assert(ll != nil);
  assert(label != nil);
  if (UIInterfaceOrientationIsPortrait(currLayoutOrientation)
      && UIInterfaceOrientationIsLandscape(newOrientation)) {
    CGPoint newCenter = ll.center;
    newCenter.y -= LOCVIEW_LOCLABEL_OFFSET;
    ll.center = newCenter;
    CGRect newFrame = label.frame;
    newFrame.origin.y -= LOCVIEW_LABEL_OFFSET;
    newFrame.size.height -= LOCVIEW_LABEL_HDIFF;
    label.frame = newFrame;
  }
  else if (UIInterfaceOrientationIsLandscape(currLayoutOrientation)
           && UIInterfaceOrientationIsPortrait(newOrientation)) {
    CGPoint newCenter = ll.center;
    newCenter.y += LOCVIEW_LOCLABEL_OFFSET;
    ll.center = newCenter;
    CGRect newFrame = label.frame;
    newFrame.origin.y += LOCVIEW_LABEL_OFFSET;
    newFrame.size.height += LOCVIEW_LABEL_HDIFF;
    label.frame = newFrame;
  }
  currLayoutOrientation = newOrientation;
}  

- (void)dealloc {
  locationManager.delegate = nil;
  [locationManager release], locationManager = nil;
  [super dealloc];
}


#pragma mark AdViewDelegate methods

- (CLLocation *)locationInfo {
  CLLocation *loc = [locationManager location];
  AWLogInfo(@"AdView asking for location: %@", loc);
  return loc;
}


#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  [locationManager stopUpdatingLocation];
  self.locLabel.text = [NSString stringWithFormat:@"Error getting location: %@",
                        [error localizedDescription]];
  AWLogError(@"Failed getting location: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  self.locLabel.text = [NSString stringWithFormat:@"%lf %lf",
                        newLocation.coordinate.longitude,
                        newLocation.coordinate.latitude];
}

@end
