require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  test "should have a file attached" do
    document = Document.new
    document.save

    document.valid?

    assert_includes(document.errors[:file], "doit être rempli(e)")
  end
end
