require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should validate all fields have been filled in" do
    user = User.new
    user.save
    user.valid?

    attributes = [:username, :first_name, :last_name, :email, :company, :city]

    attributes.each do |attribute|
      assert_includes(user.errors[attribute], "doit être rempli(e)")
    end
  end

  test "email is unique" do
    user_1 = users(:one)
    user_2 = User.new(user_1.attributes)

    user_2.valid?

    assert_includes(user_2.errors[:email], "n'est pas disponible")
  end

  test "email is case insensitive" do
    user_1 = users(:one)
    user_2 = User.new(user_1.attributes)
    user_2.email = user_1.email.upcase

    user_2.valid?

    assert_includes(user_2.errors[:email], "n'est pas disponible")
  end
end
