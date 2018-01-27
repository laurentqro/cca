require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should validate all fields have been filled in" do
    user = User.new
    user.valid?

    attributes = [:username, :first_name, :last_name, :email, :city]

    attributes.each do |attribute|
      assert_includes(user.errors[attribute], "doit être rempli(e)")
    end
  end

  test "should validate the presence of a company" do
    user = User.new
    user.valid?

    assert_includes(user.errors[:company], "doit exister")
  end

  test "username is unique" do
    user_1 = users(:one)
    user_2 = User.new(user_1.attributes)

    user_2.valid?

    assert_includes(user_2.errors[:username], "n'est pas disponible")
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

  test "email has a valid format" do
    user = users(:one)
    user.email = "&@#(*$@3x7ple.com"
    user.valid?
    assert_includes(user.errors[:email], "n'est pas valide")
  end

  test "status is active by default" do
    user = users(:one)
    assert user.active?
  end

  test "group is 'partner' by default" do
    user = users(:one)
    assert user.partner?
  end
end
