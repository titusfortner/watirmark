module Watirmark
  module Actions

    attr_accessor :records

    def run(*args)
      begin
        @records << @model if @records.size == 0
        before_all if respond_to?(:before_all)
        @records.each do |record|
          @model = hash_to_model(record) if Hash === record
          args.each do |method|
            before_each if respond_to?(:before_each)
            self.send(method)
            after_each if respond_to?(:after_each)
          end
        end
        after_all if respond_to?(:after_all)
      ensure
        @records = []
      end
    end

    def search_for_record
      if @search
        search_controller = @search.new(@supermodel)
        if search_controller.respond_to?(:current_record_visible?)
          return if search_controller.current_record_visible?
        end
        search_controller.create
      end
    end

    # Navigate to the View's edit page and for every value in
    # the models hash, verify that the html element has
    # the proper value for each keyword
    def verify
      search_for_record
      @view.edit @model
      verify_data
    end

    # Navigate to the View's edit page and
    # verify all values in the models hash
    def edit
      search_for_record
      @view.edit @model
      populate_data
    end

    # Navigate to the View's create page and
    # populate with values from the models hash
    def create
      @view.create @model
      populate_data
    end

    def verify_until(&block)
      run_with_stop_condition(:verify, block)
    end

    def edit_until(&block)
      run_with_stop_condition(:edit, block)
    end

    def create_until(&block)
      run_with_stop_condition(:create, block)
    end

    # Navigate to the View's create page and
    # populate with values from the models hash
    def get
      unless @view.exists? @model
        @view.create @model
        populate_data
      end
    end

    def delete
      @view.delete @model
    end

    def copy
      @view.copy @model
    end

    def restore
      @view.restore @model
    end

    def archive
      @view.archive @model
    end

    def publish
      @view.publish @model
    end

    def unpublish
      @view.unpublish @model
    end

    def activate
      @view.activate @model
    end

    def deactivate
      @view.deactivate @model
    end

    def locate_record
      @view.locate_record @model
    end

    # Navigate to the View's create page and verify
    # against the models hash. This is useful for making
    # sure that the create page has the proper default
    # values and contains the proper elements
    def check_defaults
      @view.create @model
      verify_data
    end
    alias :check_create_defaults :check_defaults


    # A helper function for translating a string into a
    # pattern match for the beginning of a string
    def starts_with(x)
      /^#{Regexp.escape(x)}/
    end

    # Stubs so converted XLS->RSPEC files don't fail
    def before_all; end
    def before_each; end
    def after_all; end
    def after_each; end

    private

    def run_with_stop_condition(method, block)
      catch :stop_condition_met do
        begin
          Watirmark::Session.instance.stop_condition_block = block
          send(method)
        ensure
          Watirmark::Session.instance.stop_condition_block = Proc.new{}
        end
        raise Watirmark::TestError, "Expected a stop condition but no stop conditon met!"
      end
    end


  end
end