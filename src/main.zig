const std = @import("std");
const listUtils = @import("./list.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var list = try listUtils.GenericList(u32).init(allocator);
    defer list.deinit();

    try list.push(3);

    std.debug.print("{any}\n", .{list.items[0..list.pos]});

    _ = list.pop();
    std.debug.print("{any}\n", .{list.items[0..list.pos]});
}
