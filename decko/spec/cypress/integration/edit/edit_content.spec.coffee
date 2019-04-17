describe 'edit content', () ->
  before ->
    cy.login()

  specify "edit content modal", () ->
    cy.visit("/A?view=edit")
    cy.tinymce_set_content("new content")
    cy.el("submit-modal").click()
    cy.contains "new content"

  specify "double click", () ->
    cy.ensure "editmodes", "{{A+B}} {{B|edit: inline}} {{T|edit: full}}"

    cy.visit "editmodes"
    cy.get(".SELF-a-b").dblclick()
    cy.get("#a-b-edit-view").contains("Cancel").click()
    cy.get(".SELF-b").dblclick()
    cy.get("#b-edit_inline-view").contains("Cancel").click()
    cy.get(".SELF-t").dblclick()
    cy.get(".bridge-main #t-bridge-view").contains("Cancel").click()
