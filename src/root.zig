const std = @import("std");
const Writer = std.Io.Writer;
const vm = @import("vm.zig");

pub const VM = vm.VM;
pub const Exception = vm.Exception;
pub const html = @import("html.zig");
pub const css = @import("css.zig");
pub const Ast = @import("Ast.zig");
pub const syntax_types = @import("syntax-types");
pub const Language = syntax_types.Language;
pub const max_size = syntax_types.max_size;
pub const Range = syntax_types.Range;
pub const Line = syntax_types.Line;
pub const Span = syntax_types.Span;

pub const HtmlSafe = struct {
    bytes: []const u8,

    pub fn format(
        self: HtmlSafe,
        out_stream: *Writer,
    ) !void {
        for (self.bytes) |b| {
            switch (b) {
                '&' => try out_stream.writeAll("&amp;"),
                '>' => try out_stream.writeAll("&gt;"),
                '<' => try out_stream.writeAll("&lt;"),
                '\'' => try out_stream.writeAll("&apos;"),
                '\"' => try out_stream.writeAll("&quot;"),
                else => try out_stream.writeByte(b),
            }
        }
    }
};

pub const utils = struct {
    pub fn IteratorContext(comptime Value: type) type {
        return struct {
            idx: u32 = undefined,
            tpl: *const VM(Value).Template = undefined,

            pub fn up(lc: @This()) Value {
                return lc.tpl.loopUp(lc.idx);
            }
        };
    }

    pub fn Ctx(comptime Value: type) type {
        return struct {
            _map: *const std.StringHashMapUnmanaged(Value) = undefined,

            pub fn dynamicDot(
                ctx: *const @This(),
                _: std.mem.Allocator,
                path: []const u8,
            ) !Value {
                return ctx._map.get(path) orelse .{ .err = "field not found" };
            }
            pub const docs_description =
                \\A special map that contains all the attributes
                \\ defined on `<ctx>` in the current scope.
                \\
                \\You can access the available fields using dot notation.
                \\
                \\Example:
                \\```superhtml
                \\<div>
                \\  <ctx foo="(scripty expr)" bar="(scripty expr)"> 
                \\    <span :text="$ctx.foo"></span>
                \\    <span :text="$ctx.bar"></span>
                \\  </ctx>
                \\</div>
                \\```
            ;
            pub const Builtins = struct {};
        };
    }
};

test {
    _ = @import("html.zig");
    _ = @import("Ast.zig");
    // _ = @import("template.zig");
    _ = @import("fuzz.zig");
    _ = @import("example.zig");
    _ = @import("css.zig");
}
