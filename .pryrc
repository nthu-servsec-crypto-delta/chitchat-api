# frozen_string_literal: true

require 'hirb'

Hirb.enable

Pry.config.print = proc do |output, value, _pry_| # rubocop:disable Lint/UnderscorePrefixedVariableName
  Hirb::View.view_or_page_output(value) || Pry::ColorPrinter.default(output, value, _pry_)
end
