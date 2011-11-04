class Wagn::Renderer::RichHtml
  define_view(:show) do |args|
    if ajax_call?
      home_view = params[:home_view]=='closed' ? :open : params[:home_view]
      view = params[:view] || home_view || :open
      self.render(view)
    else
      self.render_layout
    end
  end
  
  define_view(:layout) do |args|
    if @main_content = args.delete(:main_content)
      @card = Card.fetch_or_new('*placeholder')
    else
      @main_card = card
    end  

    layout_content = get_layout_content(args)
    
    args[:context] = self.context = "layout_0"
    args[:action]="view"  
    args[:relative_content] = args[:params] = params 
    
    process_content(layout_content, args)
  end
  

  define_view(:content) do |args|
    @state = :view
    self.requested_view = args[:action] = 'content'
    c = _render_core(args)
    c = "<span class=\"faint\">--</span>" if c.size < 10 && strip_tags(c).blank?
    wrap(args) { raw wrap_content(c) }
  end

  define_view(:titled) do |args|
    self.requested_view = 'titled'
    args[:action] = 'content'
    wrap(args) do
      content_tag( :h1, raw(fancy_title(card.name))) + 
      raw( wrap_content(_render_core(args)))
    end
  end

  define_view(:new) do |args|
    wrap(args) { render_partial('views/new') }
  end

  define_view(:open) do |args|
    @state = :view
    self.requested_view = 'open'
    wrap(args) { render_partial('views/open') }
  end

  define_view(:closed) do |args|
    @state = :line
    self.requested_view = args[:action] = 'closed'
    wrap(args) { render_partial('views/closed') }
  end

  define_view(:edit) do |args|
    @state=:edit
#    warn "card #{card.name} at view(:edit) = #{card.inspect}\ncard.content_template = #{card.content_template.inspect}"
    card.content_template ?  _render_multi_edit(args) : content_field(form)
  end


  define_view(:editor) do |args|
    eid = context
    form.hidden_field( :content ) +
    text_area_tag( :content_to_replace, card.content, :rows=>3, :id=>"#{eid}-tinymce", :class=>'tinymce-textarea' )
  end

  define_view(:multi_edit) do |args|
    @state=:edit
    hidden_field_tag(:multi_edit, true) + raw(_render_core(args))
  end

  define_view(:change) do |args|
    self.requested_view = args[:action] = 'content'
    wrap(args) { render_partial('views/change') }
  end

###---(  EDIT VIEWS )
  define_view(:edit_in_form) do |args|
    eform = form_for_multi
    %{
<div class="edit-area in-multi RIGHT-#{ card.cardname.tag_name.to_cardname.css_name }">
  <div class="label-in-multi">
    <span class="title">
      #{ link_to_page raw(fancy_title(self.showname || card)), (card.new_card? ? card.cardname.tag_name : card.name) }
    </span>
  </div>     
  
  <div class="field-in-multi">
    #{ self.content_field( eform, :nested=>true ) }
    #{ card.new_card? ? eform.hidden_field(:typecode) : '' }
  </div>
  #{if inst = (card.new_card? ? card.setting_card('add help', 'edit help') : card.setting_card('edit help'))
    ss = self.subrenderer(inst); ss.state= :view
    %{<div class="instruction">#{ ss.render :core }</div>}
  end}
  <div style="clear:both"></div>
</div>
    }
  end
end
