Then(/^a user authenticated message is sent$/) do
  # This step relies on the server running in-process, and having the SendsMessagetoFakeQueues module loaded in
  if TEST_CONFIG[:in_proc]
    expect(Blinkbox::Zuul::Server::Reporting.sent_messages.size).to be >= 1
    @message = Nokogiri::XML(Blinkbox::Zuul::Server::Reporting.sent_messages.pop)
    reporting_message_value("users", "/e:authenticated")
  end
end