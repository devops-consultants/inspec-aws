# author: Miles Tjandrawidjaja
require 'helper'
require 'aws_iam_root_user'

class AwsIamRootUserTest < Minitest::Test
  def setup
    @mock_conn = Minitest::Mock.new
    @mock_client = Minitest::Mock.new

    @mock_conn.expect :iam_client, @mock_client
  end

  def test_access_key_count_returns_from_summary_account
    expected_keys = 2
    test_summary_map = OpenStruct.new(
      summary_map: { 'AccountAccessKeysPresent' => expected_keys },
    )
    @mock_client.expect :get_account_summary, test_summary_map

    assert_equal expected_keys, AwsIamRootUser.new(@mock_conn).access_key_count
  end

  def test_has_mfa_enabled_returns_true_when_account_mfa_devices_is_one
    test_summary_map = OpenStruct.new(
      summary_map: { 'AccountMFAEnabled' => 1 },
    )
    @mock_client.expect :get_account_summary, test_summary_map

    assert_equal true, AwsIamRootUser.new(@mock_conn).has_mfa_enabled?
  end

  def test_has_mfa_enabled_returns_false_when_account_mfa_devices_is_zero
    test_summary_map = OpenStruct.new(
      summary_map: { 'AccountMFAEnabled' => 0 },
    )
    @mock_client.expect :get_account_summary, test_summary_map

    assert_equal false, AwsIamRootUser.new(@mock_conn).has_mfa_enabled?
  end
end
