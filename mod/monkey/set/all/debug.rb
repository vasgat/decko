format :html do
  view :debug, perms: :always_ok? do
    core_section_config(card).map do |item|
      section(*item)
    end
  end

  def always_ok?
    Card::Auth.always_ok?
  end

  def core_section_config subject
    [["Sets", tabs("set modules" => set_modules_accordion(subject),
                   "all modules" => singleton_modules_list(subject),
                   "patterns" => set_patterns_breadcrumb(subject))],
     ["Views", tabs("by format" => subformat(subject)._render_views_by_format,
                    "by name" => subformat(subject)._render_views_by_name)],
     ["Events", tabs(create: "<pre>#{subject.events(:create)}</pre>",
                     update: "<pre>#{subject.events(:update)}</pre>",
                     delete: "<pre>#{subject.events(:delete)}</pre>")],
     ["Cache/DB Comparison", cache_comparison_table(subject)]]
  end

  def set_modules_accordion subject
    accordion do
      set_module_ancestor_hash(subject).each_with_object([]) do |(setmod, anc), array|
        context = setmod.to_name.key
        array << accordion_item(setmod, body: list_group(anc), context: context)
      end
    end
  end

  def set_module_ancestor_hash subject
    subject.set_modules.each_with_object({}) do |sm, hash|
      ans = sm.ancestors
      ans.shift
      hash[sm.to_s] = ans if ans.present?
    end
  end

  def set_patterns_breadcrumb subject
    links = subject.patterns.reverse.map { |pattern| link_to_card pattern.to_s }
    breadcrumb links
  end

  def singleton_modules_list subject
    all_mods = subject.singleton_class.ancestors.map(&:to_s)
    all_mods.shift
    list_group all_mods
  end

  def cache_comparison_table subject
    cache_card = Card.fetch(subject.key)
    db_card    = Card.find_by_key(subject.key)
    return unless cache_card && db_card

    table(
      %i[name updated_at updater_id content inspect].map do |field|
        [field.to_s,
         h(cache_card.send(field)),
         h(db_card.send(field))]
      end,
      header: ["Field", "Cache Val", "Database Val"]
    )
  end

  def section title, content
    %(
      <h2>#{title}</h2>
      #{content}
    )
  end

  # def class_locations klass
  #   methods = defined_methods(klass)
  #   file_groups = methods.group_by { |sl| sl[0] }
  #   file_counts = file_groups.map do |file, sls|
  #     lines = sls.map { |sl| sl[1] }
  #     count = lines.size
  #     line = lines.min
  #     { file: file, count: count, line: line }
  #   end
  #   file_counts.sort_by! { |fc| fc[:count] }
  #   file_counts.map { |fc| [fc[:file], fc[:line]] }
  # end
  #
  # def defined_methods klass
  #   methods =
  #     klass.methods(false).map { |m| klass.method(m) } +
  #     klass.instance_methods(false).map { |m| klass.instance_method(m) }
  #   methods.map!(&:source_location)
  #   methods.compact!
  #   methods
  # end
end
