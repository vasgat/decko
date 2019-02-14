describe 'edit content', () ->
  before ->
    cy.login()

  specify "edit content modal", () ->
    cy.visit("/A?view=edit")
    cy.tinymce_type("new content")
    cy.el("submit-modal").click()
    cy.contains "new content"

