require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without username" do
    user = User.new
    user.save
    user.valid?

    attributes = [:username, :first_name, :last_name, :email, :company, :city]

    attributes.each do |attribute|
      assert_includes(user.errors[attribute], "can't be blank")
    end
  end
end
