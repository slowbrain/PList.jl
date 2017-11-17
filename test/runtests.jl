using PList
using PList.SimpleParser
using Base.Test

@testset "All Tests" begin

    @testset "SimpleParser tests" begin
        # helper function for testing.
        token_producer(s::String) = reverse([token for token in Lexer(s)])

        plist_tokens = token_producer("{eggs = spam; foo = (bar, \"foo bar\");}")
        strnum_tokens = token_producer("one 2 three 3 five")

        @test pop!(plist_tokens) == Token(LBRACE, "{")
        @test pop!(plist_tokens) == Token(STRING, "eggs")
        @test pop!(plist_tokens) == Token(EQUAL, "=")
        @test pop!(plist_tokens) == Token(STRING, "spam")
        @test pop!(plist_tokens) == Token(SEMICOLON, ";")
        @test pop!(plist_tokens) == Token(STRING, "foo")
        @test pop!(plist_tokens) == Token(EQUAL, "=")
        @test pop!(plist_tokens) == Token(LPAREN, "(")
        @test pop!(plist_tokens) == Token(STRING, "bar")
        @test pop!(plist_tokens) == Token(COMMA, ",")
        @test pop!(plist_tokens) == Token(STRING, "foo bar")
        @test pop!(plist_tokens) == Token(RPAREN, ")")
        @test pop!(plist_tokens) == Token(SEMICOLON, ";")
        @test pop!(plist_tokens) == Token(RBRACE, "}")
        @test pop!(strnum_tokens) == Token(STRING, "one")
        @test pop!(strnum_tokens) == Token(NUMBER, "2")
        @test pop!(strnum_tokens) == Token(STRING, "three")
        @test pop!(strnum_tokens) == Token(NUMBER, "3")
        @test pop!(strnum_tokens) == Token(STRING, "five")

        lexer = Lexer("{eggs = spam; foo = (bar, \"foo bar\");}")
        p = Parser(lexer)
        @test look_ahead_type(p) == LBRACE
        next_token(p)
        @test look_ahead_type(p) == STRING
        next_token(p)
        @test look_ahead_type(p) == EQUAL
        next_token(p)
        @test look_ahead_type(p) == STRING
        next_token(p)
        @test look_ahead_type(p) == SEMICOLON
        next_token(p)
        @test look_ahead_type(p) == STRING
        next_token(p)
        @test look_ahead_type(p) == EQUAL
        next_token(p)
        @test look_ahead_type(p) == LPAREN
        next_token(p)
        @test look_ahead_type(p) == STRING
        next_token(p)
        @test look_ahead_type(p) == COMMA
        next_token(p)
        @test look_ahead_type(p) == STRING
        next_token(p)
        @test look_ahead_type(p) == RPAREN
        next_token(p)
        @test look_ahead_type(p) == SEMICOLON
        next_token(p)
        @test look_ahead_type(p) == RBRACE
        next_token(p)
        @test look_ahead_type(p) == EOF

        strange_tokens = token_producer("\"Dot(u Vector2D) float64\" \"()\$0\"")
        @test pop!(strange_tokens) == Token(STRING, "Dot(u Vector2D) float64")
        @test pop!(strange_tokens) == Token(STRING, "()\$0")    
    end

    @testset "PList tests" begin
        @test writeplist_string(Dict()) == "{}"
        @test writeplist_string([]) == "()"
        @test writeplist_string("foobar") == "foobar"
        @test writeplist_string("foo bar") == "\"foo bar\""
        @test writeplist_string(1234) == "1234"
        @test writeplist_string([1, 2, 3, 4]) == "(1, 2, 3, 4)"
        @test writeplist_string(["one", "two", "three"]) == "(one, two, three)"
        @test writeplist_string(["first number", "second number"]) == "(\"first number\", \"second number\")"
        @test writeplist_string(Dict("foo" => "bar")) == "{foo = bar;}"
        @test writeplist_string(Dict("one" => 1)) == "{one = 1;}"

        @test writeplist_string([1, [2, 3], 4]) == "(1, (2, 3), 4)"
        @test writeplist_string(Dict("colors" => ["red", "green", "blue"])) == "{colors = (red, green, blue);}"

        @test readplist_string("1234") == 1234
        @test readplist_string("foobar") == "foobar"
        @test readplist_string("(1, 2, 3, 4)") == [1, 2, 3, 4]
        @test readplist_string("(one, two, three)") == ["one", "two", "three"]
        @test readplist_string("{foo = bar;}") == Dict("foo" => "bar")
        @test readplist_string("{one = 1;}") == Dict("one" => 1)
        @test readplist_string("<0fbd77 1c2735ae>") == UInt8[0x0f, 0xbd, 0x77, 0x1c, 0x27, 0x35, 0xae]
        @test readplist_string("<ffff>") == UInt8[0xff, 0xff]
        @test readplist_string("<00 01 02 03>") == UInt8[0x00, 0x01, 0x02, 0x03]
        @test readplist_string("{bin = <abcdef>;}") == Dict("bin" => UInt8[0xab, 0xcd, 0xef])
        
        dict = readplist("example.plist")

        @test !isempty(dict)
        @test haskey(dict, "Dogs")
        @test length(dict["Dogs"][1]) == 3
        @test dict["Dogs"][1]["Name"] == "Scooby Doo"
        @test dict["Dogs"][1]["Age"] == 43
        @test dict["Dogs"][1]["Colors"] == ["Brown", "Black"]
        @test dict["BinaryData"] == UInt8[0x0f, 0xbd, 0x77, 0x1c, 0x27, 0x35, 0xae]
    end
end