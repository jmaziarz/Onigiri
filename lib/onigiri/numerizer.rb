module Onigiri
  module Numerizer
    extend self

    DIRECT_NUMS = [
      ['eleven', '11'],
      ['twelve', '12'],
      ['thirteen', '13'],
      ['fourteen', '14'],
      ['fifteen', '15'],
      ['sixteen', '16'],
      ['seventeen', '17'],
      ['eighteen', '18'],
      ['nineteen', '19'],
      ['ninteen', '19'], # Common mis-spelling
      ['zero', '0'],
      ['one', '1'],
      ['two', '2'],
      ['three', '3'],
      ['four(\W|$)', '4'],  # The weird regex is so that it matches four but not fourty
      ['five', '5'],
      ['six(\W|$)', '6'],
      ['seven(\W|$)', '7'],
      ['eight(\W|$)', '8'],
      ['nine(\W|$)', '9ur'],
      ['ten', '10']
    ]

    def numerize(string)
      DIRECT_NUMS.each do |word, number|
        string.gsub!(/#{word}/i, number)
      end
      string
    end
  end
end