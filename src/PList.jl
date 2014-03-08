#!/usr/bin/env julia
module PList

export  readplist,
        readplist_string,
        writeplist,
        writeplist_string
                
using SimpleParser
        
encode(key::String, obj) = string(key, " = ", encode(obj), ";")

function encode(dict::Dict{Any, Any})
    string("{", join([encode(key, value) for (key, value) in dict]), "}")
end

function encode(array::Vector{Any})
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
    token_type = parser.look_ahead.typ
    lexeme = parser.look_ahead.lexeme
    
    if token_type == NUMBER
        match(parser, NUMBER); integer(lexeme)
    elseif token_type == STRING
        match(parser, STRING); lexeme
    elseif token_type == '('
        parse_array(parser)
    elseif token_type == '{'
        parse_dict(parser)
    end
end


function parse_array(parser::Parser)
    array = cell(0)
    
    match(parser, '(')
    if look_ahead_type(parser) == ')'
        match(parser, ')')
        return array
    end
    push!(array, parse_obj(parser))
    while look_ahead_type(parser) != ')'
        match(parser, ',')
        push!(array, parse_obj(parser))
    end
    match(parser, ')')
    array
end

function parse_dict(parser::Parser)
    dict =  Dict{Any, Any}()
    
    match(parser, '{')
    while look_ahead_type(parser) != '}'
        key = parse_obj(parser)::String
        match(parser, '=')
        dict[key] = parse_obj(parser)
        match(parser, ';')
    end
    match(parser, '}')
    dict
end

function readplist_string(text::String)
    lexer = Lexer(text)
    parser = Parser(lexer)
    parse_obj(parser)    
end

function readplist(stream::IO)
    text = readall(stream)
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
