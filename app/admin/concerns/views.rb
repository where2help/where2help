module Concerns
  module Views
    def self.included(base)
      base.send(:index) { render 'index', context: self }
      base.send(:show) { render 'show', context: self }
      base.send(:form, partial: 'form')
    end
  end
end
