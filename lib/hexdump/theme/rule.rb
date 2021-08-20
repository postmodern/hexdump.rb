require 'hexdump/theme/ansi'

require 'strscan'

module Hexdump
  class Theme
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

      # Highlighting rules for exact strings.
      #
      # @return [Hash{String => ANSI}]
      attr_reader :highlight_strings

      # Highlighting rules for matching substrings.
      #
      # @return [Hash{String => ANSI}]
      attr_reader :highlight_regexps

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

        @highlight_strings = {}
        @highlight_regexps = {}

        if highlights
          highlights.each do |pattern,style|
            highlight(pattern,style)
          end
        end
      end

      #
      # The highlighting rules.
      #
      # @return [Hash{String,Regexp => ANSI}]
      #   The combination of {#highlight_strings} and {#highlight_regexps}.
      #
      def highlights
        @highlight_strings.merge(@highlight_regexps)
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
      # @raise [ArgumentError]
      #   The given pattern was not a String or Regexp.
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
        ansi = ANSI.new(style)

        case pattern
        when String
          @highlight_strings[pattern] = ansi
        when Regexp
          @highlight_regexps[pattern] = ansi
        else
          raise(ArgumentError,"pattern must be a String or Regexp: #{pattern.inspect}")
        end
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
        if (!@highlight_strings.empty? || !@highlight_regexps.empty?)
          apply_highlight(string)
        elsif @style
          "#{@style}#{string}#{@reset}"
        else
          string
        end
      end

      private

      def apply_highlight(string)
        if (ansi = @highlight_strings[string])
          # highlight the whole string
          "#{ansi}#{string}#{@reset}"
        else
          scanner    = StringScanner.new(string)
          new_string = String.new

          until scanner.eos?
            matched = false

            @highlight_regexps.each do |regexp,ansi|
              if (match = scanner.scan(regexp))
                # highlight the match
                new_string << "#{ansi}#{match}#{@reset}"
                new_string << "#{@style}" unless scanner.eos?
                matched = true
                break
              end
            end

            unless matched
              # next char
              new_string << scanner.getch
            end
          end

          if @style
            new_string.prepend(@style) unless new_string.start_with?("\e")
            new_string << @reset       unless new_string.end_with?(@reset)
          end

          new_string
        end
      end

    end
  end
end
