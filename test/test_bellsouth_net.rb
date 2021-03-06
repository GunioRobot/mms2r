require File.join(File.dirname(__FILE__), "test_helper")

class TestBellsouthNet < Test::Unit::TestCase
  include MMS2R::TestHelper

  def test_image_from_blackberry
    mail = mail('suncom-blackberry.mail')
    mms = MMS2R::Media.new(mail)

    assert_equal "2068675309", mms.number
    assert_nil mms.media['text/plain']

    assert_not_nil mms.media['image/jpeg'].first
    assert_match(/Windows-1252\?B\?SU1HMDAwNjUuanBn/, mms.media['image/jpeg'].first)
    mms.purge
  end
end
