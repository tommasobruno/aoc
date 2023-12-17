const std = @import("std");
const test_utils = std.testing;

pub fn GenericList(comptime T: type) type {
    return struct {
        allocator: std.mem.Allocator,
        pos: usize,
        items: []T,

        const Self = GenericList(T);

        pub fn init(allocator: std.mem.Allocator) !Self {
            return .{ .allocator = allocator, .items = try allocator.alloc(T, 4), .pos = 0 };
        }

        pub fn deinit(self: Self) void {
            self.allocator.free(self.items);
        }

        pub fn push(self: *Self, v: T) !void {
            const pos = self.pos;
            const len = self.items.len;

            // Check for array to be full
            if (pos == len) {
                var larger = try self.allocator.alloc(T, len * 2);
                @memcpy(larger[0..len], self.items);

                self.allocator.free(self.items);
                self.items = larger;
            }

            self.items[pos] = v;
            self.pos = pos + 1;
        }

        pub fn pop(self: *Self) ?T {
            const pos = self.pos;
            const last = self.items[pos];
            if (last != undefined) {
                self.pos = pos - 1;

                self.items[pos] = undefined;
                return last;
            }

            return null;
        }
    };
}

test "GenericList no leaks" {
    var list = try GenericList(u8).init(test_utils.allocator);
    defer list.deinit();

    try list.push(3);
    try list.push(2);

    try test_utils.expectEqual(list.items[0], 3);
    try test_utils.expectEqual(list.items[1], 2);

    _ = list.pop();

    try test_utils.expectEqual(list.items[1], undefined);
}
