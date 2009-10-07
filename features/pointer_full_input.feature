#Feature: Pointer full input
# In order be able to do things like multiple file uploads
# As a User
# I want a full input view on pointers.
#
# 
#
#Scenario: Creating a card with full input
#  Given I create Search card "phone+*options" with content "{"type":"Phrase"}"
#  And I create Pointer card "phone+*rform"
#  And I create Phrase card "phone+*input" with content "full"
#  And I create Phrase card "phone+*autoname" with content "1"
#  When I go to card "Joe User+phone"
#  And I fill in cards_joe_user_plus_phone_plus_1_content with "is you is"
#  And I follow (the add new one link)
#  And I fill in cards_joe_user_plus_phone_plus_1_content with "is you aint"
#  And I press "Create"
#  And I go to card "Joe User+phone"
#  Then I should see "is you is"
#  And I should see "is you aint"
 
 
