module Watirmark
  module Dialogs

    def current_window_index
      Page.browser.windows.find_index(Page.browser.window)
    end

    def with_modal_dialog &blk
      Page.browser.window(index: current_window_index+1).use &blk
    end

    def close_chrome_windows
      Page.browser.windows(url: /chrome-extension/).each {|win| win.close}
    end

    def close_modal_window
      Page.browser.window(index: current_window_index+1).close if Page.browser.windows.size >= current_window_index
    end
  end
end