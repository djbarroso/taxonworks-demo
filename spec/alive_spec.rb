require 'spec_helper'

describe "specs working in Rubymine" do
  it "should pass" do
    expect(true).to be_true 
  end
end

describe "mike's test" do
  specify "'foo' is not equal to 'bar'" do
    a = "foo"
    b = "bar"
    expect(a).not_to eq(b) 

    expect(a != b) 
    expect(a == b).to eq(false) 
    expect(a == b).not_to eq(true) 
    expect(a != b).to eq(true) 
  end
end

describe "can find one string in another" do
  specify "should find 'sd' in 'asdf'" do
    a = 'sd'
    b = 'asdf'
    expect(b).to include(a)
    expect(b).to match(/sd/)
    expect(b).to match(/#{a}/)
    expect(b).not_to match(/fdsa/)
    expect(b =~ /#{a}/)
  end
end

describe "matt's test" do 
  # it/specify are aliases 
  specify "that foo is not found in some hash in either keys or values" do
    some_hash = {a: 1, b: 2, c: [], d: nil, blorf: "borf"}
    expect(some_hash.keys.select{|a| a == "foo"}.size).to eq(0)  
    expect(some_hash.keys.select{|a| a == "foo"}.size == 0)
    expect(some_hash.values.select{|a| a == "foo"}).to match_array([]) 

    # one line version
    expect((some_hash.values + some_hash.keys).select{|a| a=="foo"}.size).to eq(0) 

    # one liners
    expect(some_hash['foo'] && some_hash.values.include?('foo'))
    expect(some_hash.flatten.include?('foo')).to be(false)

    # alternate 2 line version
    expect(some_hash.values.select{|a| a == "foo"}).to have(0).things
    expect(some_hash.values.select{|a| a == "foo"}).to eql([])
  end
end

describe "dmitry's test2" do
  it "42 is within 10-50" do
    expect(10..50).to cover(42)
  end
end

describe "rich's test" do
  it "test number of keys" do
    expect({:a=>:b}.keys).to have(1).things
  end
end

describe "Beth's test" do
  specify "'freedom' ends with 'dom'" do
    expect("freedom").to end_with("dom")
  end
end

describe "mb's test" do
  specify "that [1,2,3] has 3 elements" do
    expect([1,2,3].length == 3)
  end
end
