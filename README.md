# Onigiri - A Delicious Ingredient Parser.

Give onigiri an ingredient description from a recipe and it will parse the ingredeint name and the ammount used.

For example 

    result = Onigiri::Onigiri.parse('5 tablespoons of tomato sauce')
    result.status       # :success
    result.ammount      # 5.0
    result.measurement  # 'tbsp'
    result.ingredient   # 'tomato sauce'

or 

    result = Onigiri::Onigiri.parse('10 large chopped onions')
    result.status         # :success
    result.ammount        # 5.0
    result.measurement    # 'tbsp'
    result.modifier       # 'choppped'
    result.ingredient     # 'tomato sauce'

it can also handle written ammounts such as *a* banana i.e. 1 banana or 1/2, 3/4 etc

    Onigiri::Onigiri.parse('a frozen banana')
    result.ammount # 1.0
    result.modifier # 'frozen'
    ...

    Onigiri::Onigiri.parse('1/2 diced pepper')
    result.ammount # .5
    result.modifier # 'diced'
    ...

If it can't parse a string for any reason resut.status will return :failed or :amibigous

*:failed* means epic fail and the string is propbably not an ingredient description at all

*:ambiguous* means the passed string could possibly be an ingredient description but it couldnt parse it (there were some matches but not enough to parse reliably) 

    result.text # holds the original string
    result.normalized_text # returns a cleaned up version of the string (probably of no use)

I havently created a gem version of this but you can use bundler to install via 

    gem 'omusubi', :git => '....'

(there already is a gem called onigiri so i have called it omusubi in the gemspec (a synonym for onigiri) - this is a todo to fix ).

## TODO

_Lots_ 

- Onigiri::Onigiri is annoying, dont need Onigiri class.
- remove definitions of ingredients, measurements etc to their own files.
- and more!


