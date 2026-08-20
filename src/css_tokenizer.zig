pub const syntax_types = @import("syntax-types");
pub const Span = syntax_types.Span;
pub const Tokenizer = @import("css/Tokenizer.zig");

test {
    _ = Tokenizer;
}
