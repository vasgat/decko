format :html do
  RELATED_ITEMS =
    [
      ["by name", [["children",       :children],
                   ["mates",        :mates],
                   # FIXME: optimize and restore
                  ],
      ],
      ["by content", [["links out", :links_to],
                      ["links in", :linked_to_by],
                      #["nests", :nests],
                      #["nested by", :nested_by],
                      ["references out", :refers_to],
                      ["references in",  :referred_to_by]],
      ],
      # ["by edit", [["creator", :creator],
      #              ["editors", :editors],
      #              ["last edited", :last_edited]]
      # ]
    ].freeze

  view :engage_tab, wrap: { div: { class: "m-3 mt-4 _engage-tab" } }, cache: :never do
    [render_follow_section, discussion_section].compact
  end

  view :history_tab, wrap: :slot do
    class_up "d0-card-body",  "history-slot"
    voo.hide :act_legend
    acts_bridge_layout card.history_acts
  end

  view :related_tab do

    RELATED_ITEMS.map do |category, items|
      if category == "by name" && card.name.junction?
        items = card.name.ancestors.map() + items
      end
      wrap_with(:p) do
        [wrap_with(:span, category),
          bridge_pills(bridge_pill_items(items, "Related"))]
      end
    end.join "\n"
  end

  view :rules_tab, unknown: true do
    class_up "card-slot", "flex-column"
    wrap do
      nest current_set_card, view: :bridge_rules_tab
    end
  end

  view :account_tab do
    bridge_pills bridge_pill_items(account_items, "Account")
  end

  view :follow_section, wrap: :slot, cache: :never do
    follow_section
  end

  view :guide_tab, unknown: true do
    render_guide
  end

  def discussion_section
    return unless show_discussion?

    field_nest(:discussion, view: :titled, title: "Discussion", show: :comment_box,
                            hide: [:menu])
  end

  def account_items
    %i[account roles created edited follow].map do |item|
      if item == :account
        [tr(:details), item, { view: :edit, hide: %i[edit_name_row edit_type_row] }]
      else
        [tr(item), item]
      end
    end
  end

  def bridge_pills items
    list_tag class: "nav nav-pills _auto-single-select bridge-pills flex-column",
             items: { class: "nav-item" } do
      items
    end
  end

  def bridge_pill_items data, breadcrumb
    data.map do |text, field, extra_opts|
      opts = bridge_link_opts.merge("data-toggle": "pill")
      opts.merge! breadcrumb_data(breadcrumb)
      if extra_opts
        classes = extra_opts.delete :class
        add_class opts, classes if classes
        opts.deep_merge! extra_opts
      end
      opts["data-cy"] = "#{text.to_name.key}-pill"
      add_class opts, "nav-link"
      link_to_card [card, field], text,  opts
    end
  end
end

