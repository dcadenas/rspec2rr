class RSpec2RR
  VERSION = '0.1.0'

  def self.to_rr spec
    return unless spec
    spec = convert_stub(spec)
    spec = convert_should_receive(spec)
    spec = convert_should_not_receive(spec)
    spec = convert_with(spec)
    spec = convert_and_return(spec)
    spec
  end

  def self.convert_stub(spec)
    spec.gsub(/([\S]+)\.stub!\(:?([^\)]+)\)(.*)/, 'stub(\1).\2\3')
  end

  def self.convert_should_receive(spec)
    spec.gsub(/([\S]+)\.should_receive\(:?([^\)]+)\)(.*)/, 'mock(\1).\2\3')
  end

  def self.convert_should_not_receive(spec)
    spec.gsub(/([\S]+)\.should_not_receive\(:?([^\)]+)\)(.*)/, 'dont_allow(\1).\2\3')
  end

  def self.convert_with(spec)
    spec.gsub(/((stub|mock|dont_allow).+)\.with\((.+)\)(.*)/, '\1(\3)\4')
  end

  def self.convert_and_return(spec)
    spec.gsub(/\.and_return(.+)(.*)/, ' {\1}\2').gsub(/\{\((.+)\)\}/, '{\1}')
  end
end
