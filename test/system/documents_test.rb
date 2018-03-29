require "application_system_test_case"

class DocumentsTest < ApplicationSystemTestCase
  test 'deleting a document' do
    user = users(:partner)
    sign_in_as(user)
    project = projects(:pyramid)

    Assignment.create(user: user, project: project)

    s3_url = %r{https://#{ENV['AWS_S3_BUCKET']}.s3.#{ENV['AWS_S3_REGION']}.amazonaws.com}

    stub_request(:put, s3_url).to_return(body: '', status: 200)

    Document.create(
      file: File.open('test/fixtures/files/pdf-sample.pdf'),
      folder: project.root_folder,
      user: user
    )

    visit project_folder_url(project, project.root_folder)

    stub_request(:delete, s3_url).to_return(body: '', status: 200)

    find_link(title: 'Supprimer ce document').click

    assert_text 'Document supprimé avec succès.'
  end
end
