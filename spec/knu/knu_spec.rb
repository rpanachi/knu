require "spec_helper"

describe Knu do

  subject { Knu.new("user@server.com", "1234") }

  it { should respond_to(:user) }
  it { should respond_to(:password) }
  it { should respond_to(:format) }

  it { should respond_to(:receitaCPF) }

end
