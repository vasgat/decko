require "decko/application"
require_relative "alias"

CARD_TASKS = (
  %i[eat migrate reset_cache reset_tmp seed setup sow update] +
  # { assets: %i[refresh code wipe] },
  # above caused loading problem because of .sort is rails' #run_tasks_blocks
  [{ migrate: %i[cards structure core_cards deck_cards redo stamp] },
   { mod: %i[list symlink leftover uninstall install] },
   { seed: %i[build clean dump plow polish replant update] }]
).freeze

def link_task task, from: nil, to: nil, namespace: nil
  case task
  when Hash
    task.each do |key, val|
      link_task val, from: from, to: to, namespace: append_to_namespace(namespace, key)
    end
  when Array
    task.each { |t| link_task t, from: from, to: to, namespace: namespace }
  else
    shared_part = append_to_namespace namespace, task
    alias_task "#{from}:#{shared_part}", "#{to}:#{shared_part}"
  end
end

private

def alias_task name, old_name
  t = Rake::Task[old_name]
  desc t.full_comment if t.full_comment
  task name, *t.arg_names do |_, args|
    # values_at is broken on Rake::TaskArguments
    args = t.arg_names.map { |a| args[a] }
    t.invoke(args)
  end
end

def append_to_namespace namespace, part
  [namespace, part].compact.join(":")
end

link_task CARD_TASKS, from: :decko, to: :card
