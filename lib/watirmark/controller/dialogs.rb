module Watirmark
  module Dialogs

    # Default case of using 2nd window and closing it when complete
    def with_popup_window &blk
      new_window = Page.browser.window(:index, 1)
      new_window.use &blk
      new_window.close if new_window.exists?
    end

    alias_method :with_popup_window, :with_modal_dialog

    def close_chrome_windows
      chrome_window = Page.browser.window(:url, /chrome-extension/)
      chrome_window.close if chrome_window.exists?
    end

    # Default case of closing 2 windows
    def close_popup_window
      second_window = Page.browser.window(:index, 1)
      second_window.close if second_window_window.exists?
    end

    alias_method :close_popup_window, :close_modal_dialog

  end
end