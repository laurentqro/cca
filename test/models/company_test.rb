require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test "must have a name" do
    company = Company.new
    company.valid?

    assert_includes(company.errors[:name], "doit être rempli(e)")
  end

  test "must have a unique name" do
    Company.create(name: "Foo")
    duplicate_company = Company.new(name: "Foo")
    duplicate_company.valid?

    assert_includes(duplicate_company.errors[:name], "n'est pas disponible")
  end
end
