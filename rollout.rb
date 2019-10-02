require 'rox/server/rox_server'

User = Struct.new(:id, :name, :cart_size)

class RoxContainer
  attr_accessor :videoChat, :fileSupport, :specialDiscount

  def initialize
    @videoChat = Rox::Server::RoxFlag.new(true)
    @fileSupport = Rox::Server::RoxFlag.new(true)
    @specialDiscount = Rox::Server::RoxFlag.new(false)
  end
end

roxContainer = RoxContainer.new

Rox::Server::RoxServer.set_custom_boolean_property('hasItemsInShoppingCart') do |context|
  context['user'].cart_size > 0
end

Rox::Server::RoxServer.register('my-app', roxContainer)
Rox::Server::RoxServer.setup('5d6059c1c3cb8b1634f3030f').join

user = User.new(1, 'josh', 0)

puts "videoChat is #{roxContainer.videoChat.enabled? ? "enabled" : "disabled"}"
puts "videoChat is #{roxContainer.fileSupport.enabled? ? "enabled" : "disabled"}"

puts "cart size is #{user.cart_size}"

context = {'user' => user}

puts "specialDiscount is #{roxContainer.specialDiscount.enabled?(context) ? "enabled" : "disabled"}"

b1 = Rox::Server::RoxServer.dynamic_api.enabled?('default.newFlag', false)
puts "dynamic newFlag is #{b1}"
