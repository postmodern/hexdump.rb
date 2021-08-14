module Hexdump
  class Style
    #
    # Represents an ANSI control sequence.
    #
    # @api private
    #
    # @since 1.0.0
    #
    class ANSI
      # ANSI reset control sequence
      RESET = "\e[0m"

      STYLES = {
        bold:      "\e[1m",
        faint:     "\e[2m",
        italic:    "\e[3m",
        underline: "\e[4m",
        invert:    "\e[7m",
        strike:    "\e[9m",
        black:     "\e[30m",
        red:       "\e[31m",
        green:     "\e[32m",
        yellow:    "\e[33m",
        blue:      "\e[34m",
        magenta:   "\e[35m",
        cyan:      "\e[36m",
        white:     "\e[37m",

        on_black:   "\e[40m",
        on_red:     "\e[41m",
        on_green:   "\e[42m",
        on_yellow:  "\e[43m",
        on_blue:    "\e[44m",
        on_magenta: "\e[45m",
        on_cyan:    "\e[46m",
        on_white:   "\e[47m"
      }

      # The style name(s).
      #
      # @return [Symbol, Array<Symbol>] style
      attr_reader :style

      # The ANSI string.
      #
      # @return [String]
      attr_reader :ansi

      #
      # Initializes an ANSI control sequence.
      #
      # @param [Symbol, Array<Symbol>] style
      #
      def initialize(style)
        @style = style

        @ansi = String.new

        Array(style).each do |name|
          @ansi << STYLES.fetch(name) do
            raise(ArgumentError,"unknown style: #{name}")
          end
        end
      end

      #
      # Returns the ANSI string.
      #
      # @return [String]
      #
      def to_s
        @ansi
      end

      alias to_str to_s
    end
  end
end
