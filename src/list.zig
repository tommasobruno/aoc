const std = @import("std");

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
    };
}
