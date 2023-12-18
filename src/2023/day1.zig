const std = @import("std");
const fs = std.fs;
const testing = std.testing;

pub fn solvePartOne(allocator: std.mem.Allocator) !usize {
    const file = try fs.cwd().openFile("src/2023/input_1.txt", .{});
    defer file.close();

    const rdr = file.reader();

    var sum: usize = 0;
    while (try rdr.readUntilDelimiterOrEofAlloc(allocator, '\n', 4096)) |line| {
        var first: ?u8 = null;
        var last: ?u8 = null;

        if (line.len < 2) break;

        defer allocator.free(line);
        for (line) |char| {
            if (std.ascii.isDigit(char)) {
                if (first == null) {
                    first = char - '0';
                } else {
                    last = char - '0';
                }
            }
        }

        if (last == null) {
            last = first.?;
        }

        const val = 10 * first.? + last.?;
        sum += val;
    }

    return sum;
}

test "Adevent Of Code Result Check Part 1" {
    try testing.expectEqual(try solvePartOne(testing.allocator), 53194);
}
