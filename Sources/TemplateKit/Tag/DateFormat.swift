/// Formats a floating-point time interval since epoch date to a specified format.
///
///     dateFormat(<timeIntervalSinceEpoch>, <dateFormat?>)
///
/// If no date format is supplied, a default will be used.
public final class DateFormat: TagRenderer {
    /// Creates a new `DateFormat` tag renderer.
    public init() {}

    /// See `TagRenderer`.
    public func render(tag: TagContext) throws -> Future<TemplateData> {
        /// Require at least one parameter.
        switch tag.parameters.count {
        case 1, 2: break
        default: throw tag.error(reason: "Invalid parameter count: \(tag.parameters.count). 1 or 2 required.")
        }

        let formatter = DateFormatter()
        /// Expect the date to be a floating point number.
		guard let timestamp = tag.parameters[0].double
            else { return Future.map(on: tag) { .null } }
        let date = Date(timeIntervalSince1970: timestamp)
        /// Set format as the second param or default to ISO-8601 format.
        if tag.parameters.count == 2, let param = tag.parameters[1].string {
            formatter.dateFormat = param
        } else {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }

        /// Return formatted date
        return Future.map(on: tag) { .string(formatter.string(from: date)) }
    }
}
