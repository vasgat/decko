# -*- encoding : utf-8 -*-
# rubocop:disable Lint/AmbiguousRegexpLiteral, Lint/Syntax
# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all
# features/**/*.rb files.

require "uri"
require "cgi"
require File.expand_path(
  File.join(File.dirname(__FILE__), "..", "support", "paths")
)

# Commonly used webrat steps
# http://github.com/brynary/webrat

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
  # wait_for_ajax if @javascript && (button == "Submit" || button =~ /rename/i)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )click on "([^"]*)"$/ do |link|
  click_link_or_button(link)
end

When /^(?:|I )follow "([^"]*)" within "([^"]*)"$/ do |link, parent|
  click_link_within(parent, link)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
  # wait_for_ajax if @javascript && field == "card_name"
end

When /^(?:|I )fill in "([^"]*)" with '([^']*)'$/ do |field, value|
  fill_in(field, with: value)
end

When /^(?:|I )fill in autocomplete "([^"]*)" with "([^']*)"$/ do |field, value|
  fill_autocomplete(field, with: value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, with: value)
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
  select(value, from: field)
end

When /^(?:|I )submit form$/ do
  find(:css, "button[type='submit']").click
end

# Use this step in conjunction with Rail's datetime_select helper. For example:
# When I select "December 25, 2008 10:00" as the date and time
When /^(?:|I )select "([^"]*)" as the date and time$/ do |time|
  select_datetime(time)
end

# Use this step when using multiple datetime_select helpers on a page or
# you want to specify which datetime to select. Given the following view:
#   <%= f.label :preferred %><br />
#   <%= f.datetime_select :preferred %>
#   <%= f.label :alternative %><br />
#   <%= f.datetime_select :alternative %>
# The following steps would fill out the form:
# When I select "November 23, 2004 11:20" as the "Preferred" date and time
# And I select "November 25, 2004 10:30" as the "Alternative" date and time
When /^(?:|I )select "([^"]*)" as the "([^"]*)" date and time$/ do |datetime, datetime_label|
  select_datetime(datetime, from: datetime_label)
end

# Use this step in conjunction with Rail's time_select helper. For example:
# When I select "2:20PM" as the time
# Note: Rail's default time helper provides 24-hour time-- not 12 hour time.
# Webrat will convert the 2:20PM to 14:20 and then select it.
When /^(?:|I )select "([^"]*)" as the time$/ do |time|
  select_time(time)
end

# Use this step when using multiple time_select helpers on a page or you want to
# specify the name of the time on the form.  For example:
# When I select "7:30AM" as the "Gym" time
When /^(?:|I )select "([^"]*)" as the "([^"]*)" time$/ do |time, time_label|
  select_time(time, from: time_label)
end

# Use this step in conjunction with Rail's date_select helper.  For example:
# When I select "February 20, 1981" as the date
When /^(?:|I )select "([^"]*)" as the date$/ do |date|
  select_date(date)
end

# Use this step when using multiple date_select helpers on one page or
# you want to specify the name of the date on the form. For example:
# When I select "April 26, 1982" as the "Date of Birth" date
When /^(?:|I )select "([^"]*)" as the "([^"]*)" date$/ do |date, date_label|
  select_date(date, from: date_label)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
  check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
  uncheck(field)
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
  choose(field)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  expect(page.gsub(/\s+/, " ")).to have_content(text)
  # once we're at capybara 3.5 we can use `normalize_ws: true` (ws = white space)
  # in have_content and get rid of the gsub (which is needed because
  # capybara 3 changed things in a way that shows more line breaks)
end

Then /^(?:|I )should see in search "([^"]*)"$/ do |text|
  Capybara.ignore_hidden_elements = false
  expect(page).to have_content(text)
  Capybara.ignore_hidden_elements = true
end

Then /^(?:|I )should see file "([^"]*)"$/ do |text|
  # for unknown reasons capybara thinks that the file info is not visible
  Capybara.ignore_hidden_elements = false
  expect(page).to have_content(text)
  Capybara.ignore_hidden_elements = true
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  expect(page).to_not have_content(text)
end

Then /^show me the page$/ do
  save_and_open_page
end

def fill_autocomplete field, options={}
  fill_in field, with: options[:with]
  page.execute_script %{ $('##{field}').trigger('focus').trigger('keydown') }
  selector = %{ul.ui-autocomplete li.ui-menu-item div.ui-menu-item-wrapper:contains('#{options[:with]}'):first}
  page.should have_selector("ul.ui-autocomplete li.ui-menu-item div.ui-menu-item-wrapper")
  page.execute_script "$(\"#{selector}\").trigger('mouseenter').click()"
  wait_for_ajax
end
