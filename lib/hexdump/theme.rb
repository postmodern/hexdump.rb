require 'hexdump/theme/rule'

module Hexdump
  #
  # Represents a hexdump theme (styling + highlighting).
  #
  # @api semipublic
  #
  # @since 1.0.0
  #
  class Theme

    # The index styling/highlights.
    #
    # @return [Rule, nil]
    #
    # @api public
    attr_reader :index

    # The numeric styling/highlights.
    #
    # @return [Rule, nil]
    #
    # @api public
    attr_reader :numeric

    # The chars styling/highlights.
    #
    # @return [Rule, nil]
    #
    # @api public
    attr_reader :chars

    #
    # Initializes the theme.
    #
    # @param [Hash{:index,:numeric,:chars => Symbol,Array<Symbol>,nil}] style
    #   The default style of the index, numeric, and/or chars columns.
    #
    # @param [Hash{:index,:numeric,:chars => Hash{String,Regexp => Symbol,Array<Symbol>},nil}] highlights
    #   The highlighting rules for the index, numeric, and/or chars columns.
    #
    def initialize(style: {}, highlights: {})
      @index   = Rule.new(
                   style:      style[:index],
                   highlights: highlights[:index]
                 )

      @numeric = Rule.new(
                   style:      style[:numeric],
                   highlights: highlights[:numeric]
                 )

      @chars   = Rule.new(
                   style:      style[:chars],
                   highlights: highlights[:chars]
                )
    end

  end
end
