require 'hexdump/style/ansi'

require 'strscan'

module Hexdump
  class Style
    #
    # Represents a color highlighting rule.
    #
    # @api private
    #
    # @since 1.0.0
    #
    class Rule

      # The default style to apply to strings.
      #
      # @return [ANSI, nil]
      attr_reader :style

      # Highlighting rules to apply to matching substrings.
      #
      # @return [Hash{String,Regexp => ANSI}]
      attr_reader :highlights

      #
      # Initializes the color.
      #
      # @param [Symbol, Array<Symbol>] style
      #   The defualt style name(s). See {ANSI::PARAMETERS}.
      #
      # @param [Hash{String,Regexp => Symbol,Array<Symbol>}, nil] highlights
      #   Optional highlighting rules.
      #
      def initialize(style: nil, highlights: nil)
        @reset = ANSI::RESET
        
        @style = if style
                   ANSI.new(style)
                 end

        @highlights = {}

        if highlights
          highlights.each do |pattern,style|
            self.highlight(pattern,style)
          end
        end
      end

      #
      # Adds a highlighting rule.
      # 
      # @param [String, Regexp] pattern
      #   The exact String to highlight or regular expression to highlight.
      #
      # @param [Symbol, Array<Symbol>] style
      #   The style name(s). See {ANSI::PARAMETERS}.
      #
      # @example
      #   hexdump.style.numeric.highlight('00', :faint)
      #
      # @example
      #   hexdump.style.index.highlight(/00$/, [:white, :bold])
      #
      # @api public
      #
      def highlight(pattern,style)
        @highlights[pattern] = ANSI.new(style)
      end

      #
      # Applies coloring/highlighting to a string.
      #
      # @param [String] string
      #   The string to color/highlight.
      #
      # @return [String]
      #   The colored the string.
      #
      def apply(string)
        if @style || !@highlights.empty?
          new_string = String.new
          new_string << @style if @style

          if !@highlights.empty?
            scanner = StringScanner.new(string)

            until scanner.eos?
              matched = false

              @highlights.each do |pattern,ansi|
                if (match = scanner.scan(pattern))
                  new_string << "#{ansi}#{match}#{@reset}#{@style}"
                  matched = true
                  break
                end
              end

              unless matched
                new_string << scanner.getch
              end
            end
          else
            new_string << string
          end

          new_string << @reset if @style
          new_string
        else
          string
        end
      end

    end
  end
end
