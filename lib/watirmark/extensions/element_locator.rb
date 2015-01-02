module Watir


  class ElementCollection
    private

    def elements
      @elements ||= locator_class.new(self).locate_all
    end

  end

  class Element
    protected

    def locate
      @parent.assert_exists
      locator_class.new(self).locate
    end
  end

  class IFrame < HTMLElement
    def locate
      @parent.assert_exists

      element = locator_class.new(self).locate
      raise UnknownFrameException, "unable to locate #{@selector[:tag_name]} using #{selector_string}" if element.nil?

      @parent.reset!

      FramedDriver.new(element, driver)
    end
  end

  class ElementLocator
    def initialize(element)
      @wd               = element.instance_variable_get('@parent').wd
      @selector         = element.selector.dup
      @valid_attributes = self.class.attribute_list
      @keyword = element.keyword if element.respond_to? :keyword
    end
  end

end
