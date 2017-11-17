module PList

export  readplist,
        readplist_string,
        writeplist,
        writeplist_string
                
include("SimpleParser.jl")

using .SimpleParser
       
encode(key::String, obj) = string(key, " = ", encode(obj), ";")

function encode(dict::Dict{K, V}) where {K, V}
    string("{", join([encode(key, value) for (key, value) in dict]), "}")
end

function encode(array::Vector{T}) where T
    string( "(", join(map(encode, array), ", "), ")")
end

# Quotes strings which are not simple alphanumeric. 
function encode(s::String)
    if all(isalnum, s) && length(s) > 0 && isalpha(s[1])
        s
    else
        "\"$s\""
    end
end

encode(num::Real) = string(num)

function encode(obj)
    error("Can't encode $obj because it is of type $(typeof(obj))")
end

function parse_obj(parser::Parser)
    token_type = parser.look_ahead.kind
    lexeme = parser.look_ahead.lexeme
    
    if     NUMBER == token_type 
        match(parser, NUMBER); parse(lexeme)
    elseif STRING == token_type
        match(parser, STRING); lexeme
    elseif LPAREN == token_type
        parse_array(parser)
    elseif LBRACE == token_type
        parse_dict(parser)
    end
end


function parse_array(parser::Parser)
    array = []
    
    match(parser, LPAREN)
    if look_ahead_type(parser) == RPAREN
        match(parser, RPAREN)
        return array
    end
    push!(array, parse_obj(parser))
    while look_ahead_type(parser) != RPAREN
        match(parser, COMMA)
        push!(array, parse_obj(parser))
    end
    match(parser, RPAREN)
    array
end

function parse_dict(parser::Parser)
    dict =  Dict{Any, Any}()
    
    match(parser, LBRACE)
    while look_ahead_type(parser) != RBRACE
        key = parse_obj(parser)::String
        match(parser, EQUAL)
        dict[key] = parse_obj(parser)
        match(parser, SEMICOLON)
    end
    match(parser, RBRACE)
    dict
end

function readplist_string(text::String)
    lexer = Lexer(text)
    parser = Parser(lexer)
    parse_obj(parser)    
end

function readplist(stream::IO)
    text = readstring(stream)
    readplist_string(text)
end

function readplist(filename::String)
    open(readplist, filename)
end

writeplist_string(obj) = encode(obj)
    
function writeplist(stream::IO, obj)
    print(stream, encode(obj))
end    

function writeplist(filename::String, obj)
    open(filename, "w") do stream
        writeplist(stream, obj)
    end
end

end
