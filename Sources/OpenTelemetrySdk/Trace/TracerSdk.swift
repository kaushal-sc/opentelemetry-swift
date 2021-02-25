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
import OpenTelemetryApi

/// TracerSdk is SDK implementation of Tracer.
public class TracerSdk: Tracer {
    public let binaryFormat: BinaryFormattable = BinaryTraceContextFormat()
    public let textFormat: TextMapPropagator = W3CTraceContextPropagator()
    public var sharedState: TracerSharedState
    public var instrumentationLibraryInfo: InstrumentationLibraryInfo

    public init(sharedState: TracerSharedState, instrumentationLibraryInfo: InstrumentationLibraryInfo) {
        self.sharedState = sharedState
        self.instrumentationLibraryInfo = instrumentationLibraryInfo
    }

    public var activeSpan: Span? {
        return ContextUtils.getCurrentSpan()
    }

    public func spanBuilder(spanName: String) -> SpanBuilder {
        if sharedState.hasBeenShutdown {
            return DefaultTracer.instance.spanBuilder(spanName: spanName)
        }
        return SpanBuilderSdk(spanName: spanName,
                              instrumentationLibraryInfo: instrumentationLibraryInfo,
                              tracerSharedState: sharedState,
                              spanLimits: sharedState.activeSpanLimits)
    }

    @discardableResult public func setActive(_ span: Span) -> Scope {
        return ContextUtils.withSpan(span)
    }
}
