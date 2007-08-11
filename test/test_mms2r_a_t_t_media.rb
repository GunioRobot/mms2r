$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require File.dirname(__FILE__) + "/test_helper"
require 'test/unit'
require 'rubygems'
require 'mms2r'
require 'mms2r/media'
require 'tmail/mail'
require 'logger'

class MMS2R::ATTMediaTest < Test::Unit::TestCase
  include MMS2R::TestHelper

  def setup
    @log = Logger.new(STDOUT)
    @log.level = Logger::DEBUG
    @log.datetime_format = "%H:%M:%S"
  end

  def teardown; end

  def test_simple
    mail = TMail::Mail.parse(load_mail('att-image-01.mail').join)
    mms = MMS2R::Media.create(mail)
    assert_equal(MMS2R::ATTMedia, mms.class, "expected a #{MMS2R::ATTMedia} and received a #{mms.class}")
    mms.process

    assert(mms.media.size == 1)
    assert_nil(mms.media['text/plain'])
    assert_nil(mms.media['text/html'])
    assert_not_nil(mms.media['image/jpeg'][0])
    assert_match(/Photo_12.jpg$/, mms.media['image/jpeg'][0])

    assert_file_size(mms.media['image/jpeg'][0], 337)
    mms.purge
  end

  def test_subject
    mail = TMail::Mail.parse(load_mail('att-image-02.mail').join)
    mms = MMS2R::Media.create(mail)
    assert_equal(MMS2R::ATTMedia, mms.class, "expected a #{MMS2R::ATTMedia} and received a #{mms.class}")
    mms.process

    assert(mms.media.size == 1)
    assert_nil(mms.media['text/plain'])
    assert_nil(mms.media['text/html'])
    assert_not_nil(mms.media['image/jpeg'][0])
    assert_match(/Photo_12.jpg$/, mms.media['image/jpeg'][0])

    assert_file_size(mms.media['image/jpeg'][0], 337)

    assert_nil mms.get_subject
    mms.purge
  end
end
