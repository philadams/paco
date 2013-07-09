/* Copyright 2013 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PacoEvent.h"
#import "PacoDate.h"

@interface PacoEvent ()
@property (nonatomic, readwrite, copy) NSString *appId;
@property (nonatomic, readwrite, copy) NSString *pacoVersion;
@end

@implementation PacoEvent

- (id)init {
  self = [super init];
  if (self) {
    _appId = @"ios_paco";
    _pacoVersion = @"1";
  }
  return self;
}

+ (id)pacoEventForIOS {
  return [[PacoEvent alloc] init];
}

+ (NSDate *)pacoDateForString:(NSString *)dateStr {
  // Assuming its a long long for ms since epoch.
  long long timeInterval = [dateStr longLongValue];
  return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (id)pacoEventFromJSON:(id)jsonObject {
  PacoEvent *event = [[PacoEvent alloc] init];
  NSDictionary *eventMembers = jsonObject;
  event.who = [eventMembers objectForKey:@"who"];
  event.when = [self pacoDateForString:[eventMembers objectForKey:@"when"]];
  event.latitude = [[eventMembers objectForKey:@"lat"] longLongValue];
  event.longitude = [[eventMembers objectForKey:@"long"] longLongValue];
  event.responseTime = [self pacoDateForString:[eventMembers objectForKey:@"responseTime"]];
  event.scheduledTime = [self pacoDateForString:[eventMembers objectForKey:@"scheduledTime"]];
  event.appId = [eventMembers objectForKey:@"appId"];
  event.pacoVersion = [eventMembers objectForKey:@"pacoVersion"];
  event.experimentId = [eventMembers objectForKey:@"experimentId"];
  event.experimentName = [eventMembers objectForKey:@"experimentName"];
  event.responses = [eventMembers objectForKey:@"xxx"];
  return event;
}

- (id)generateJsonObject {
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  [dictionary setValue:self.experimentId forKey:@"experimentId"];
  [dictionary setValue:self.experimentName forKey:@"experimentName"];
  [dictionary setValue:self.who forKey:@"who"];
  [dictionary setValue:self.appId forKey:@"appId"];
  [dictionary setValue:self.pacoVersion forKey:@"pacoVersion"];
  if (self.when) {
    [dictionary setValue:[PacoDate pacoStringForDate:self.when] forKey:@"when"];
  }
  if (self.latitude) {
    [dictionary setValue:[NSString stringWithFormat:@"%lld", self.latitude] forKey:@"lat"];
  }
  if (self.longitude) {
    [dictionary setValue:[NSString stringWithFormat:@"%lld", self.longitude] forKey:@"long"];
  }
  if (self.responseTime) {
    [dictionary setValue:[PacoDate pacoStringForDate:self.responseTime] forKey:@"responseTime"];
  }
  if (self.scheduledTime) {
    [dictionary setValue:[PacoDate pacoStringForDate:self.scheduledTime] forKey:@"scheduledTime"];
  }
  if (self.responses) {
    [dictionary setValue:self.responses forKey:@"responses"];
  }
  return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
