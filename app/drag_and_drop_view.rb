class DragAndDropView < NSButton
  attr_accessor :delegate

  def initWithFrame(frame)
    super(frame)

    self.registerForDraggedTypes([NSStringPboardType, NSURLPboardType])

    self.bordered = false
    self.wantsLayer = true
    self.reset_status

    self
  end

  def reset_status
    self.title = "Waiting for drag and drop"
  end

  def draggingEntered(info)
    self.title = "Dragging..."
    self.highlight!
    NSDragOperationCopy
  end

  def draggingExited(info)
    self.reset_status
    self.unhighlight!
  end

  def prepareForDragOperation(info)
    self.unhighlight!
  end

  def performDragOperation(info)
    if info.draggingSource != self
      if info.draggingPasteboard.types.include?('NSFilenamesPboardType')
        files = info.draggingPasteboard.propertyListForType('NSFilenamesPboardType')
        self.send_delegate_event(:drag_received_for_file_paths, files)
      elsif info.draggingPasteboard.types.include?('WebURLsWithTitlesPboardType')
        url, title = info.draggingPasteboard.propertyListForType('WebURLsWithTitlesPboardType').flatten
        self.send_delegate_event(:drag_received_for_url_and_title, url, title)
      elsif info.draggingPasteboard.types.include?('public.url')
        url = info.draggingPasteboard.propertyListForType('public.url')
        self.send_delegate_event(:drag_received_for_url, url) unless url.nil?
      else
        text = info.draggingPasteboard.stringForType(NSPasteboardTypeString)
        self.send_delegate_event(:drag_received_for_text, text) unless text.nil?
      end

      self.title = "Dropped!"
      NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: 'reset_status', userInfo: nil, repeats: false)
    end
  end

  def highlight!
    @highlight = true
    self.needsDisplay = true
  end

  def unhighlight!
    @highlight = false
    self.needsDisplay = true
  end

  def drawRect(frame)
    if @highlight
      self.cell.backgroundColor = NSColor.selectedMenuItemColor
    else
      self.cell.backgroundColor = nil
    end

    super(frame)
  end

  def send_delegate_event(name, *args)
    return if self.delegate.nil?
    return unless self.delegate.respond_to?(name.to_sym)

    self.delegate.send(name, *args)
  end
end