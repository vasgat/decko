# -*- encoding : utf-8 -*-

require "../../../decko_gem"

Gem::Specification.new do |s|
  DeckoGem.shared s
  DeckoGem.mod s, "follow"
  DeckoGem.depends_on_mod s, :carrierwave

  s.summary = "follower notifications"
  s.description = ""
end
