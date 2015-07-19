require "rubygems"
require "pathname"
require "cairo"
require "pango"

def mm(_)
  inch = _ / 25.4
  inch * 72.0
end

def ボックス!(context, sx, sy, ex, ey, str)
  width = ex - sx
  height = ey - sy

  context.rounded_rectangle(sx, sy, width, height, 1.5)
  context.stroke

  description = Pango::FontDescription.new("ヒラギノ角ゴ ProN Semi-Light 9")

  layout = context.create_pango_layout
  layout.font_description = description

  layout.text = str

  str_x = sx + (width - layout.extents[0].width.to_f / Pango::SCALE) / 2.0
  str_y = sy + (height - layout.extents[0].height.to_f / Pango::SCALE) / 2.0

  context.move_to(str_x, str_y)
  context.show_pango_layout(layout)
end


def 罫線!(context, x, y, width, height, space)

  line_count = ((height - y) / space).to_i 

  start_y = y + space

  line_count.times { |i|
    context.move_to(x, start_y)
    context.line_to(width, start_y)

    start_y += space
  }

  context.stroke
end

if $0 == __FILE__
  OFFSET_X = mm(5)
  OFFSET_Y = mm(1)

  surface = Cairo::PDFSurface.new("a.pdf", :a5)
  context = Cairo::Context.new(surface)

  context.translate(OFFSET_X,OFFSET_Y)

  #context.set_source_rgb(0.6, 0.6, 0.9)
  context.set_source_rgb(0, 0, 0.5)

  box_str = ["月", "火", "水", "木", "金", "土"]

  space = (mm(210) - (OFFSET_Y * 1)) / box_str.count 

  box_str.each_with_index { |dow, i|
    context.set_line_width(mm(0.02))
    ボックス!(context, mm(5), space * i, mm(10), space * (i + 1) - OFFSET_Y, dow)

    context.set_line_width(mm(0.002))
    罫線!(context, mm(11.5), space * i, mm(11.5) + (mm(148) - mm(11.5) - OFFSET_X) / 2 - mm(3), space * (i + 1), mm(5))
    罫線!(context, mm(11.5) + (mm(148) - mm(11.5) - OFFSET_X) / 2, space * i, mm(143) - mm(3), space * (i + 1), mm(5))
  }


  context.target.finish
end

