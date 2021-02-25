# frozen_string_literal: true

require 'json'

RSpec.describe Oculo::SnsEvents::S3Notification do
  let(:message) do
    { 'Records' => [{
                      'eventVersion'      => '2.1',
                      'eventSource'       => 'aws : s3',
                      'awsRegion'         => 'ap-southeast-2',
                      'eventTime'         => '2021-02-10T07:14:09.519Z',
                      'eventName'         => 'ObjectCreated:Put',
                      'userIdentity'      => { 'principalId' => 'AWS:544757391075:jeff' },
                      'requestParameters' => { 'sourceIPAddress' => '127.0.0.1' },
                      'responseElements'  => {
                        'x-amz-request-id' => 'E1DC023B3294FFF3',
                        'x-amz-id-2'       => 'g49Knmurd55/IW0lVTucEg4CrhLn5Je7oODxRl2BjlbxCtcJR7SZ/y5QYAjW/bppiELlYpux7zmp5DjubyxTr2aLXhbzDrW8'
      },
                      's3'                => {
                        's3SchemaVersion' => '1.0',
                        'configurationId' => '7cec4c1b-00c2-480e-b4ab-af1b87c6fd51',
                        'bucket'          => {
                          'name'          => 'oculo-bad-files-go-here',
                          'ownerIdentity' => { 'principalId' => 'AN8FYB6LRFGKA' },
                          'arn'           => 'arn:aws:s3:::oculo-bad-files-go-here'
        },
                        'object'          => {
                          'key'       => 'files/cyberpunk-sorry.jpeg',
                          'size'      => 303924,
                          'eTag'      => '735f01ff550b7d9ffc79284a9498daaa',
                          'sequencer' => '00602387C3DA9D675E' }
      }
      }
    ]}.to_json
  end

  let(:sns_event) do
    { 'Records' => [
      { 'EventSource' => 'aws:sns', 'EventVersion' => '1.0',
        'EventSubscriptionArn' => 'arn:aws:sns:ap-southeast-2:544757391075:virus-testing-BadFilesUpdatesTopic-1L351O8NT3UKT:a7460cb7-8b77-46e1-8b89-3c8125290e26',
        'Sns' => {
          'Type'              => 'Notification',
          'MessageId'         => 'cdca118f-b025-5883-ad32-49123a212c5c',
          'TopicArn'          => 'arn:aws:sns:ap-southeast-2:544757391075:virus-testing-BadFilesUpdatesTopic-1L351O8NT3UKT',
          'Subject'           => 'Amazon S3 Notification',
          'Message'           => message,
          'Timestamp'         => '2021-02-10T07:14:12.719Z',
          'SignatureVersion'  => '1',
          'Signature'         => 'qUb2tsa1I8sYtuN0OlwuA/97sZH5gbwe/IDwvQpmOSdu+OvYNxkw6hNXyClHF4IFmdQk5NBtGj5mUev9YGNoXAYDBLwqd9cpN+KxIco/Qjy1NIeCi5vdamSRechDgchIjT1g/xXRbPkvNoIUBi9EerMCAAWXjpfOIU9GcH646a5df+pt+0t1KoQfjbYzQiKHs62kWexRV0/7zEin5oUWm/a9UrJy28cUqIEbTReDTyzLQKrYch/ZT0THDGTypRZATxBohN9PW4wGOP/X4S7thoeiqLwF0PAlq6zPEIKGUY6idMWV+LkgdiW9KsAzqOn9UPThYQHIymoepWcCeXSNFA==', 'SigningCertUrl' => 'https://sns.ap-southeast-2.amazonaws.com/SimpleNotificationService-010a507c1833636cd94bdb98bd93083a.pem', 'UnsubscribeUrl' => 'https://sns.ap-southeast-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:ap-southeast-2:544757391075:virus-testing-BadFilesUpdatesTopic-1L351O8NT3UKT:a7460cb7-8b77-46e1-8b89-3c8125290e26',
          'MessageAttributes' => {}
        }
      }]
    }
  end

  it 'has a version number' do
    expect(Oculo::SnsEvents::VERSION).not_to be nil
  end

  subject { described_class.new(event: sns_event) }

  its(:file_key) { is_expected.to eq 'files/cyberpunk-sorry.jpeg' }
  its(:file_size) { is_expected.to eq 303924 }

  it 'is not a test message' do
    expect(subject.s3_test_message?).to eq false
  end

  describe 'file prefix filtering' do
    it 'is false for a non-matching prefix' do
      expect(subject.has_path?('wrong/path')).to eq false
    end

    it 'is true for a matching prefix' do
      expect(subject.has_path?('files')).to eq true
    end

    it 'is true for a matching prefix with the first slash included' do
      expect(subject.has_path?('/files')).to eq true
    end
  end

  describe 'file extension checking' do
    it 'matches a single matching extension' do
      expect(subject.matches_extensions?('.jpeg')).to eq true
    end

    it 'matches a multiple matching extension' do
      expect(subject.matches_extensions?('.jpg', '.jpeg', '.png')).to eq true
    end

    it 'fails the match if none of the extensions are present' do
      expect(subject.matches_extensions?('.dcm', '.pdf', '.docx')).to eq false
    end
  end

  context 'when the event is not from SNS' do
    let(:sns_event) do
      { 'Some' => { 'Other' => { 'AWS' => 'System', 'Message' => 'Format' } } }
    end

    it 'raises InvalidSnsS3EventError' do
      expect { subject.payload }.to raise_error(Oculo::SnsEvents::InvalidSnsS3EventError)
    end
  end

  context 'when the payload in the SNS message is not from S3' do
    let(:message) do
      { 'SNS' => { 'Payload' => { 'Containing' => 'Something', 'Else' => 'Entirely' } } }.to_json
    end

    it 'raises InvalidSnsS3EventError' do
      expect { subject.file_key }.to raise_error(Oculo::SnsEvents::InvalidSnsS3EventError)
    end
  end

  context 'S3 Subscription test event' do
    let(:message) do
      {
        'Service'   => 'Amazon S3',
        'Event'     => 's3:TestEvent',
        'Time'      => '2021-02-25T02:38:50.994Z',
        'Bucket'    => 'oculo-demo-images',
        'RequestId' => '2DD5919EBFB2D455',
        'HostId'    => '7RwOahKuS+56EKBzZb6bvND5PmByEy8Rsjn2M6q2ohQR/nEW1HJeTyvtTDAiinP85+BaPXKFMfo='
      }.to_json
    end

    it 'can be checked if it is a test message' do
      expect(subject.s3_test_message?).to eq true
    end

    it 'has_path, etc are all nil or false', :aggregate_failures do
      expect(subject.has_path?('files')).to eq false
      expect(subject.matches_extensions?('.exe')).to eq false
      expect(subject.file_key).to eq nil
      expect(subject.file_size).to eq nil
    end

  end

end
