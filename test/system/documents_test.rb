require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  setup do
    sign_in_as(users(:admin))
  end

  test 'uploading a document' do
    project = projects(:one)
    folder = project.folders.first

    visit project_folder_url(project, folder)

    attach_file 'document[file]', "#{Rails.root}/test/fixtures/files/pdf-sample.pdf"
    click_button 'Soumettre le document'

    assert_equal(Document.last.file.data["metadata"]["filename"], 'pdf-sample.pdf')
  end
end
