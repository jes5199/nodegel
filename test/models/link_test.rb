require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  def test_slashy_link
    link = Link.to("*", "and/or", "jes")
    blank, namespace, name, author = link.to_href.split('/')
    assert_equal('', blank)
    assert_equal('*', namespace)
    assert_equal('jes', author)
    assert_equal("and%E2%88%95or", name)
  end
end

