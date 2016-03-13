class WriteSpan
  def initialize(context, output, span_class)
    @context = context
    @output = output
    @span_class = span_class
  end

  def execute
    @output.write "<span class='#{@span_class}'>"
    @context.push_end_tag 'span'
    @context.read_argument
  end
end