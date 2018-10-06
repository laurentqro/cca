require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  test 'deleting a document' do
    user = users(:partner)
    folder = folders(:folder_one)

    s3_url = %r{https://#{ENV['AWS_S3_BUCKET']}.s3.#{ENV['AWS_S3_REGION']}.amazonaws.com}
    stub_request(:put, s3_url).to_return(body: '', status: 200)

    sign_in_as(user)

    Assignment.create(user: user, project: folder.project)

    document = Document.create(
      folder: folder,
      user: user
    )

    document.file.attach(io: File.open('test/fixtures/files/pdf-sample.pdf'),
                         filename: 'pdf-sample.pdf',
                         content_type: 'application/pdf')

    visit project_folder_url(folder.project, folder)

    stub_request(:delete, s3_url).to_return(body: '', status: 200)

    click_button(title: 'Supprimer ce document')

    assert_text 'Document supprimé avec succès.'
  end
end
