using PList
using Base.Test

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

dict = readplist("example.plist")

@test !isempty(dict)
@test haskey(dict, "Dogs")
@test length(dict["Dogs"][1]) == 3
@test dict["Dogs"][1]["Name"] == "Scooby Doo"
@test dict["Dogs"][1]["Age"] == 43
@test dict["Dogs"][1]["Colors"] == ["Brown", "Black"]