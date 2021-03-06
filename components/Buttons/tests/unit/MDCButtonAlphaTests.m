// Copyright 2020-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <XCTest/XCTest.h>

#import "MaterialButtons.h"
#import "MaterialShadowElevations.h"
#import "MaterialShadowLayer.h"
#import "MaterialShapes.h"
#import "MaterialTypography.h"

@interface MDCButtonAlphaTests : XCTestCase
@property(nonatomic, strong, nullable) MDCButton *button;
@end

@implementation MDCButtonAlphaTests

- (void)setUp {
  [super setUp];

  self.button = [[MDCButton alloc] init];
}

- (void)tearDown {
  self.button = nil;

  [super tearDown];
}

- (void)testAlphaRestoredWhenReenabled {
  // Given
  CGFloat alpha = (CGFloat)0.5;

  // When
  self.button.alpha = alpha;
  self.button.enabled = NO;
  self.button.enabled = YES;

  // Then
  XCTAssertEqualWithAccuracy(alpha, self.button.alpha, 0.0001);
}

- (void)testEnabledAlphaNotSetWhileDisabled {
  // Given
  CGFloat alpha = (CGFloat)0.2;

  // When
  self.button.alpha = alpha;
  self.button.enabled = NO;
  self.button.alpha = 1 - alpha;
  self.button.enabled = YES;

  // Then
  XCTAssertEqualWithAccuracy(alpha, self.button.alpha, (CGFloat)0.0001);
}

- (void)testDisabledAlpha {
  // Given
  CGFloat alpha = 0.5;

  // When
  [self.button setDisabledAlpha:alpha];
  self.button.enabled = NO;

  // Then
  XCTAssertEqualWithAccuracy(alpha, self.button.alpha, (CGFloat)0.0001);
}

@end
