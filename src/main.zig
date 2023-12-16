const std = @import("std");

const User = struct { size: usize };

pub fn main() !void {
    var i: i8 = 0;
    while (i < 10) : (i += 1) {
        std.debug.print("{d}\n", .{i});
    }
}
