module Where2help
  class Operation
    attr_reader :model

    def self.call(params = {})
      new.perform(params)
    end

    def perform(params)
      raise NotImplementedError, "Need to implement the #perform method in inherited classes"
    end


    def self.present(params = {})
      new.setup_model(params)
    end

    def setup_model!(params)
      # noop
    end
  end
end
