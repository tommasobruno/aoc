const std = @import("std");
const FileSource = std.build.FileSource;

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const day_one = b.addTest(.{
        .root_source_file = FileSource.relative("src/2023/day1.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(day_one);
    const run_install_tests = b.addInstallArtifact(day_one, .{});

    const test_day_one_step = b.step("test-day-one", "Run day 1 tests");
    test_day_one_step.dependOn(&run_unit_tests.step);
    test_day_one_step.dependOn(&run_install_tests.step);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
