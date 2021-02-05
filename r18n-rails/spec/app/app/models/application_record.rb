# frozen_string_literal: true

## Base AR class for this application
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
