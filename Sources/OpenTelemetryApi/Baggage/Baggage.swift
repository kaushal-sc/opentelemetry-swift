// Copyright 2020, OpenTelemetry Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

/// A map from EntryKey to EntryValue and EntryMetadata that can be used to
/// label anything that is associated with a specific operation.
/// For example, Baggages can be used to label stats, log messages, or
/// debugging information.
public protocol Baggage: AnyObject {
    /// Builder for the Baggage class
    static func baggageBuilder() -> BaggageBuilder

    /// Returns an immutable collection of the entries in this Baggage. Order of
    /// entries is not guaranteed.
    func getEntries() -> [Entry]

    ///  Returns the EntryValue associated with the given EntryKey.
    /// - Parameter key: entry key to return the value for.
    func getEntryValue(key: EntryKey) -> EntryValue?
}

public func == (lhs: Baggage, rhs: Baggage) -> Bool {
    guard type(of: lhs) == type(of: rhs) else { return false }
    return lhs.getEntries().sorted() == rhs.getEntries().sorted()
}
