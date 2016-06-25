class AppDelegate
  attr_accessor :status_menu

  def applicationDidFinishLaunching(notification)
    @app_name = NSBundle.mainBundle.infoDictionary['CFBundleDisplayName']

    @drag_and_drop = DragAndDropView.alloc.initWithFrame([[0, 0], [150, 30]])
    @drag_and_drop.delegate = self

    @status_item = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength).init
    @status_item.setView(@drag_and_drop)
  end

  def drag_received_for_file_paths(paths)
    self.alert!("Received: #{paths.join(',')}")
  end

  def drag_received_for_text(text)
    self.alert!("Received: #{text}")
  end

  def drag_received_for_url(url)
    self.alert!("Received: #{url}")
  end

  def drag_received_for_url_and_title(url, title)
    self.alert!("Received: #{url}")
  end

  def alert!(message)
    NSRunAlertPanel("DragAndDropStatusDemo", message, "OK", nil, nil)
  end
end