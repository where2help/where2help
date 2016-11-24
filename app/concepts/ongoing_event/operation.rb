class OngoingEventOperation
  class Index < Where2help::Operation
    def setup_model!(params)
    end
  end

  class Show < Where2help::Operation
    def setup_model!(params)
    end
  end

  class Create < Where2help::Operation
    def setup_model!(params)
    end

    def process(params)
    end
  end

  class Update < Where2help::Operation
    def setup_model!(params)
    end

    def process(params)
    end
  end

  class Destroy < Where2help::Operation
    def process(params)
    end
  end
end
