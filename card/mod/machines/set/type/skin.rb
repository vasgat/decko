include_set Abstract::Machine
include_set Abstract::MachineInput

store_machine_output filetype: "css"

include_set Pointer

format :html do
  view :thumbnail, template: :haml do
  end

  def select_button target=parent.card
    link_to_card target, "Select",
                 path: { action: :update, card: { content: "[[#{card.name}]]" } },
                 class: "btn btn-sm btn-outline-primary"
  end

  def customize_button target=parent.card
    link_to_card target, "Customize",
                 path: { action: :update, card: { content: "[[#{card.name}]]" },
                         customize: true, theme: card.codename },
                 class: "btn btn-sm btn-outline-primary"
  end
end
