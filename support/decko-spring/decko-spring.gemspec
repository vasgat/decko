# -*- encoding : utf-8 -*-

require "../../decko_gem"

DeckoGem.gem "decko-spring" do |s, d|
  s.summary = "spring integration for decko development"
  s.description = "Spring speeds up development by keeping your application running " \
                  "in the background. Read more: https://github.com/rails/spring"
  d.depends_on ["listen",                   "> 3.5"],
               ["spring",                   "> 3"],
               ["spring-commands-rspec",    "> 1.0"],
               ["spring-commands-cucumber", "> 1.0"]
end
