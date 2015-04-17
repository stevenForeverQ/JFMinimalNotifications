//
//  JFMinimalNotification_Tests.m
//  JFMinimalNotification Tests
//
//  Created by Jeremy Fox on 4/17/15.
//  Copyright (c) 2015 Jeremy Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "JFMinimalNotification.h"

@interface ViewController ()
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@end

@interface JFMinimalNotification_Tests : XCTestCase <JFMinimalNotificationDelegate>
@property (nonatomic, strong) ViewController* viewController;
@property (nonatomic, strong) XCTestExpectation* expectation;
@end

@implementation JFMinimalNotification_Tests

- (void)setUp {
    [super setUp];
    if (!self.viewController) {
        self.viewController = [ViewController new];
        self.viewController.view.frame = CGRectMake(0, 0, 320, 480);
    }
}

- (void)tearDown {
    self.expectation = nil;
    [super tearDown];
}

- (void)testNotificationIsAssignedAValidSuperview {
    [self.viewController.view addSubview:self.viewController.minimalNotification];
    CGFloat notificationMinY = CGRectGetMinY(self.viewController.minimalNotification.frame);
    CGFloat viewMaxY = CGRectGetMaxY(self.viewController.view.frame);
    XCTAssert(self.viewController.minimalNotification.superview, @"Notification must have a superview before being displayed");
    XCTAssert(notificationMinY >= viewMaxY, @"Notification should be placed at the bottom of it's superview - outside the visible area of the view");

}

- (void)testNotificationIsDisplayed {
    self.expectation = [self expectationWithDescription:@"Animation Complete Expectation"];
    [self.viewController showToastWithMessage:@"Testing..."];
    self.viewController.minimalNotification.delegate = self;
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        CGFloat notificationMinY = CGRectGetMinY(self.viewController.minimalNotification.frame);
        CGFloat viewMaxY = CGRectGetMaxY(self.viewController.view.frame);
        XCTAssert(notificationMinY < viewMaxY, @"Notification must be visible - within the views visible rect");
    }];
}

- (void)testNotificationIsDismissed {
    self.expectation = [self expectationWithDescription:@"Animation Complete Expectation"];
    self.viewController.minimalNotification.delegate = self;
    [self.viewController dismiss:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        CGFloat notificationMinY = CGRectGetMinY(self.viewController.minimalNotification.frame);
        CGFloat viewMaxY = CGRectGetMaxY(self.viewController.view.frame);
        XCTAssert(notificationMinY >= viewMaxY, @"Notification should be placed at the bottom of it's superview - outside the visible area of the view");
    }];
}

- (void)testRepeatedCallsToShowAndDismissWorkProperly {
    self.expectation = [self expectationWithDescription:@"Animation Complete Expectation"];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController dismiss:nil];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController dismiss:nil];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController dismiss:nil];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController dismiss:nil];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController dismiss:nil];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController dismiss:nil];
    [self.viewController showToastWithMessage:@"Testing..."];
    
    [self.viewController dismiss:nil];
    [self.viewController dismiss:nil];
    [self.viewController dismiss:nil];
    
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController showToastWithMessage:@"Testing..."];
    [self.viewController showToastWithMessage:@"Testing..."];
    
    self.viewController.minimalNotification.delegate = self;
    [self.viewController dismiss:nil];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        CGFloat notificationMinY = CGRectGetMinY(self.viewController.minimalNotification.frame);
        CGFloat viewMaxY = CGRectGetMaxY(self.viewController.view.frame);
        XCTAssert(notificationMinY >= viewMaxY, @"Notification should be placed at the bottom of it's superview - outside the visible area of the view");
    }];
}

//- (void)testAsyncCallsToShowAndDismissWorkProperly {
//    self.expectation = [self expectationWithDescription:@"Animation Complete Expectation"];
//    [self.viewController showToastWithMessage:@"Testing..."];
//
//    dispatch_queue_t queue = dispatch_queue_create("com.jeremyfox.JFMinimalNotification.Tests", NULL);
//    dispatch_async(queue, ^{
//        [self.viewController showToastWithMessage:@"Testing..."];
//    });
//    
//    self.viewController.minimalNotification.delegate = self;
//    [self.viewController dismiss:nil];
//    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
//        CGFloat notificationMinY = CGRectGetMinY(self.viewController.minimalNotification.frame);
//        CGFloat viewMaxY = CGRectGetMaxY(self.viewController.view.frame);
//        XCTAssert(notificationMinY >= viewMaxY, @"Notification should be placed at the bottom of it's superview - outside the visible area of the view");
//    }];
//}

- (void)didShowNotification:(JFMinimalNotification*)notification {
    if (self.expectation) {
        [self.expectation fulfill];
    }
}

- (void)didDismissNotification:(JFMinimalNotification *)notification {
    if (self.expectation) {
        [self.expectation fulfill];
    }
}

@end
