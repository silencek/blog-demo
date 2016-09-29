//
//  OpenAMapURLRequestViewController.m
//  officialDemo2D
//
//  Created by xiaoming han on 15/6/12.
//  Copyright (c) 2015年 AutoNavi. All rights reserved.
//

#import "OpenAMapURLRequestViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#define kURLSearchKeyword       @"购物"

@interface OpenAMapURLRequestViewController ()
{
    MAPointAnnotation *_startAnnotation;
    MAPointAnnotation *_endAnnotation;
}

@end

@implementation OpenAMapURLRequestViewController

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"路径-驾车",
                                             @"路径-公交",
                                             @"路径-步行",
                                             @"POI搜索",
                                             nil]];
    segmentedControl.momentary = YES;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(urlSearchAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *mayTypeItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, mayTypeItem, flexbleItem, nil];
}

- (void)urlSearchAction:(UISegmentedControl *)segmentedControl
{
    NSLog(@"index :%d", @(segmentedControl.selectedSegmentIndex).intValue);
    
    BOOL openAMapSuccess = NO;
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0:
        {
            AMapRouteConfig *config = [AMapRouteConfig new];
            config.appName = [self getApplicationName];
            config.appScheme = [self getApplicationScheme];
            config.startCoordinate = _startAnnotation.coordinate;
            config.destinationCoordinate = _endAnnotation.coordinate;
            config.routeType = AMapRouteSearchTypeDriving;
            openAMapSuccess = [AMapURLSearch openAMapRouteSearch:config];
        }
            break;
        case 1:
        {
            AMapRouteConfig *config = [AMapRouteConfig new];
            config.appName = [self getApplicationName];
            config.appScheme = [self getApplicationScheme];
            config.startCoordinate = _startAnnotation.coordinate;
            config.destinationCoordinate = _endAnnotation.coordinate;
            config.routeType = AMapRouteSearchTypeTransit;
            openAMapSuccess = [AMapURLSearch openAMapRouteSearch:config];
        }
            break;
        case 2:
        {
            AMapRouteConfig *config = [AMapRouteConfig new];
            config.appName = [self getApplicationName];
            config.appScheme = [self getApplicationScheme];
            config.startCoordinate = _startAnnotation.coordinate;
            config.destinationCoordinate = _endAnnotation.coordinate;
            config.routeType = AMapRouteSearchTypeWalking;
            openAMapSuccess = [AMapURLSearch openAMapRouteSearch:config];
        }
            break;
        case 3:
        {
            AMapPOIConfig *config = [AMapPOIConfig new];
            config.appName = [self getApplicationName];
            config.appScheme = [self getApplicationScheme];
            config.keywords = kURLSearchKeyword;
            config.leftTopCoordinate = _startAnnotation.coordinate;
            config.rightBottomCoordinate = _endAnnotation.coordinate;
            openAMapSuccess = [AMapURLSearch openAMapPOISearch:config];
        }
            break;
        default:
            break;
    }
    
    if(!openAMapSuccess)
    {
        [AMapURLSearch getLatestAMapApp];
    }
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        
        if (annotation == _startAnnotation)
        {
            annotationView.pinColor = MAPinAnnotationColorGreen;
        }
        else
        {
            annotationView.pinColor = MAPinAnnotationColorRed;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initToolBar];
    
    _startAnnotation = [[MAPointAnnotation alloc] init];
    _startAnnotation.coordinate = CLLocationCoordinate2DMake(39.924693, 116.389771);
    _startAnnotation.title = @"start";
    [self.mapView addAnnotation:_startAnnotation];
    
    _endAnnotation = [[MAPointAnnotation alloc] init];
    _endAnnotation.coordinate = CLLocationCoordinate2DMake(39.904693, 116.439771);
    _endAnnotation.title = @"end";
    [self.mapView addAnnotation:_endAnnotation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

@end
