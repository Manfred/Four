require File.expand_path('../test_helper', __dir__)

describe Kicker::OptionParser do
  it "parses various inputs" do
    [
      [
        '',
        [[], []]
      ],
      [
        'clear',
        [[], ['clear']]
      ],
      [
        '-v',
        [[['v']], []]
      ],
      [
        '-v -v',
        [[['v'], ['v']], []]
      ],
      [
        '-r a -r b a clear',
        [[['r', 'a'], ['r', 'b']], ['a', 'clear']]
      ],
      [
        '--a -a --b true --h',
        [[['a'], ['a'], ['b', 'true'], ['h']], []]
      ]
    ].each do |input, expected|
      Kicker::OptionParser.parse(input.split(' ')).should == expected
    end
  end
end