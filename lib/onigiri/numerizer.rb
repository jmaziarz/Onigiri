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
      ['nine(\W|$)', '9'],
      ['ten', '10']
    ]

    TENS_NUMS = [
      ["ten","10"],
      ["twenty", "20"],
      ["thirty", "30"],
      ["fourty", "40"],
      ["fifty",  "50"],
      ["sixty",  "60"],
      ["seventy","70"],
      ["eighty", "80"],
      ["ninety", "90"]
    ]

    BIG_NUMS = [
      ["hundred","100"],
      ["thousand", "1000"]
    ]

    RANGES = [
      ['', $1]
    ]

    def numerize(string)
      #first fractions 1/2 => 0.5, 1 1/2 => 1.5
      string.gsub!(/(\d\d?)\/(\d\d?\d?)/) { ($1.to_f/ $2.to_f).round(2).to_s} 
      #add converted fraction to any preceding numbers e.g. 1 1/2 => 1 0.5 => 1.5
      string.gsub!(/(\d\d?) (\d\.\d\d?\d?\d?)/) { ($1.to_f + $2.to_f).round(2).to_s }

      DIRECT_NUMS.each do |word, number|
        string.gsub!(/\b#{word}\b/i, number)
      end

      #deal with tens numbers such as "twenty two" first.
      TENS_NUMS.each do |word, number|
        string.gsub!(/#{word} (\d)/i){ "#{(number.to_i + $1.to_i).to_s}" }
      end

      #then deal with the simple tens numbers i.e. 20, 30, 40 etc
      TENS_NUMS.each do |word, number|
        string.gsub!(/\b#{word}\b/i, number)
      end

      #TODO deal with use of 'and' e.g. one hundred *and* fifty
      BIG_NUMS.each do |word, number|
        string.gsub!(/\b#{word}\b/i, number)
      end

      #convert ranges : 1 or 2 apples => 1 apple
      string.gsub!(/\b(\d\d?\d?)\s?(-|or|to)\s?(\d\d?\d?)\b/, '\1')

      string
    end
  end
end